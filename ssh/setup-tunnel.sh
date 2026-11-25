#!/bin/bash
# Set up a locked-down reverse SSH tunnel user and sshd drop-in config on the
# VPS (assumes Debian 12+ or Ubuntu 22.04+).

set -euo pipefail

function usage
{
    cat <<EOF
Usage: sudo $0 [options] [pubkey-file]

Configure a locked-down /bin/false user and sshd Match block on the VPS so a
remote host (e.g., Raspberry Pi) can maintain a loopback-only reverse SSH tunnel
on any unprivileged port. Reads the public key from stdin if [pubkey-file] is
omitted.

Options:
  -u, --user USER      Tunnel username (default: tunnel)
  -h, --help           Show this help message

Examples:
  sudo $0 /tmp/id_ed25519_vps_tunnel.pub
  cat id_ed25519_vps_tunnel.pub | sudo $0
EOF
}

function die
{
    echo "Error: $*" >&2
    exit 1
}

function read_pubkey
{
    local file="${1:-}"
    local raw

    if [[ -z "$file" ]]; then
        if [[ -t 0 ]]; then
            echo "Reading public key from stdin (paste key and press Ctrl-D)..." >&2
        else
            echo "Reading public key from stdin..." >&2
        fi
        raw=$(cat)
    else
        [[ -f "$file" ]] || die "Public key file not found: ${file}"
        raw=$(cat "$file")
    fi

    raw=$(printf '%s\n' "$raw" | sed '/^[[:space:]]*$/d')
    local line_count
    line_count=$(printf '%s\n' "$raw" | wc -l | tr -d ' ')
    (( line_count == 1 )) || die "Expected a single SSH public key line, got ${line_count}"

    [[ "$raw" =~ ^(ssh|ecdsa|sk)-[^[:space:]]+[[:space:]]+[A-Za-z0-9+/=]+([[:space:]].*)?$ ]] \
        || die "Input does not look like a valid OpenSSH public key"

    printf '%s\n' "$raw"
}

function ensure_tunnel_user
{
    local tunnel_user="$1"
    local pubkey="$2"

    if id "$tunnel_user" >/dev/null 2>&1; then
        echo "User '${tunnel_user}' already exists; ensuring shell is /bin/false..."
        usermod -s /bin/false "$tunnel_user"
    else
        echo "Creating locked-down system user '${tunnel_user}'..."
        useradd -r -m -s /bin/false "$tunnel_user"
    fi

    local home_dir
    home_dir=$(getent passwd "$tunnel_user" | cut -d: -f6)
    [[ -n "$home_dir" && -d "$home_dir" ]] \
        || die "Home directory for '${tunnel_user}' does not exist"

    local ssh_dir="${home_dir}/.ssh"
    local auth_keys="${ssh_dir}/authorized_keys"

    install -d -m 700 -o "$tunnel_user" -g "$tunnel_user" "$ssh_dir"
    touch "$auth_keys"
    chown "${tunnel_user}:${tunnel_user}" "$auth_keys"
    chmod 600 "$auth_keys"

    if grep -Fqx "$pubkey" "$auth_keys"; then
        echo "Public key already present in ${auth_keys}."
    else
        printf '%s\n' "$pubkey" >> "$auth_keys"
        echo "Added public key to ${auth_keys}."
    fi
}

function configure_sshd
{
    local tunnel_user="$1"
    local dropin_file="/etc/ssh/sshd_config.d/99-reverse-tunnel-${tunnel_user}.conf"
    local backup=""

    if [[ -f "$dropin_file" ]]; then
        backup=$(mktemp)
        cp -p "$dropin_file" "$backup"
    fi

    cat > "$dropin_file" <<EOF
# Managed by https://github.com/ymattw/profiles/blob/master/ssh/setup-tunnel.sh
Match User ${tunnel_user}
    # Drop stale tunnel sessions within ~90s so the forwarded port frees quickly
    ClientAliveInterval 30
    ClientAliveCountMax 3
    AllowTcpForwarding remote
    GatewayPorts no
    PermitListen localhost:* 127.0.0.1:* [::1]:*
    AllowAgentForwarding no
    PermitTunnel no
    X11Forwarding no
    PermitTTY no
    ForceCommand /bin/false
EOF
    chmod 644 "$dropin_file"
    echo "Wrote sshd drop-in config: ${dropin_file}"

    if ! /usr/sbin/sshd -t; then
        echo "sshd config validation failed; rolling back..." >&2
        if [[ -n "$backup" ]]; then
            cp -p "$backup" "$dropin_file"
            rm -f "$backup"
        else
            rm -f "$dropin_file"
        fi
        die "Aborted due to invalid sshd configuration"
    fi
    [[ -z "$backup" ]] || rm -f "$backup"
}

function verify_sshd
{
    local tunnel_user="$1"
    local effective
    effective=$(/usr/sbin/sshd -T -C "user=${tunnel_user}")

    echo "Effective sshd config for user '${tunnel_user}':"
    printf '%s\n' "$effective" \
        | grep -E '^(clientaliveinterval|clientalivecountmax|allowtcpforwarding|gatewayports|permitlisten|allowagentforwarding|permittunnel|x11forwarding|permittty|forcecommand) ' \
        | sed 's/^/  /'

    printf '%s\n' "$effective" | grep -qx 'allowtcpforwarding remote' \
        || die "Verification failed: allowtcpforwarding is not 'remote'"
    printf '%s\n' "$effective" | grep -qx 'gatewayports no' \
        || die "Verification failed: gatewayports is not 'no'"
    printf '%s\n' "$effective" | grep -qx 'forcecommand /bin/false' \
        || die "Verification failed: forcecommand is not '/bin/false'"
}

function main
{
    local tunnel_user="tunnel"

    while (( $# > 0 )); do
        case "$1" in
            -u|--user)
                [[ $# -ge 2 ]] || die "Missing value for $1"
                tunnel_user="$2"
                shift 2
                ;;
            -h|--help)
                usage
                exit 0
                ;;
            -*)
                die "Unknown option: $1 (use --help for usage)"
                ;;
            *)
                break
                ;;
        esac
    done

    (( $# <= 1 )) || die "Unexpected argument: $2"
    local pubkey_file="${1:-}"

    (( EUID == 0 )) || die "Please run this script as root (e.g., sudo $0 ...)"

    local pubkey
    pubkey=$(read_pubkey "$pubkey_file")

    ensure_tunnel_user "$tunnel_user" "$pubkey"
    configure_sshd "$tunnel_user"
    systemctl reload ssh
    echo "Reloaded systemd service 'ssh'."
    verify_sshd "$tunnel_user"
}

main "$@"
