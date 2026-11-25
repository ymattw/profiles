#!/bin/bash
# Install and enable the persistent reverse SSH tunnel systemd service on a
# Raspberry Pi or Linux host behind NAT (assumes Debian 12+ or Ubuntu 22.04+).

set -euo pipefail

function usage
{
    cat <<EOF
Usage: sudo $0 [options] <vps[:port]> <remotePort>

Create, enable, and start a persistent systemd reverse SSH tunnel service that
forwards <remotePort> on the VPS loopback interface to this host's local sshd.

Arguments:
  <vps[:port]>             VPS hostname or IP, with optional SSH port (default: 22)
  <remotePort>             Loopback port to bind on the VPS (e.g., 2222)

Options:
  -t, --tunnel-user USER   Locked-down user on the VPS (default: tunnel)
  -k, --key PATH           Tunnel private key path
                           (default: ~/.ssh/id_ed25519_vps_tunnel)
  -s, --service NAME       systemd service name (default: reverse-ssh-tunnel)
  -h, --help               Show this help message
EOF
}

function die
{
    echo "Error: $*" >&2
    exit 1
}

function validate_port
{
    local label="$1"
    local port="$2"
    [[ "$port" =~ ^[0-9]+$ ]] && (( port >= 1 && port <= 65535 )) \
        || die "${label} must be an integer between 1 and 65535: ${port}"
}

function detect_local_sshd_port
{
    local port
    port=$(/usr/sbin/sshd -T 2>/dev/null | awk '$1 == "port" { print $2; exit }')
    echo "${port:-22}"
}

function main
{
    local pi_user="${SUDO_USER:-$USER}"
    local tunnel_user="tunnel"
    local key_path=""
    local service_name="reverse-ssh-tunnel"
    local args=()

    while (( $# > 0 )); do
        case "$1" in
            -t|--tunnel-user)
                [[ $# -ge 2 ]] || die "Missing value for $1"
                tunnel_user="$2"
                shift 2
                ;;
            -k|--key)
                [[ $# -ge 2 ]] || die "Missing value for $1"
                key_path="$2"
                shift 2
                ;;
            -s|--service)
                [[ $# -ge 2 ]] || die "Missing value for $1"
                service_name="$2"
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
                args+=("$1")
                shift
                ;;
        esac
    done

    (( ${#args[@]} == 2 )) || { usage >&2; exit 1; }
    (( EUID == 0 )) || die "Please run with sudo (e.g., sudo $0 <vps[:port]> <remotePort>)"

    local vps_spec="${args[0]}"
    local remote_port="${args[1]}"
    local vps_host=""
    local vps_port="22"

    if [[ "$vps_spec" =~ ^\[([^]]+)\]:([0-9]+)$ ]]; then
        vps_host="${BASH_REMATCH[1]}"
        vps_port="${BASH_REMATCH[2]}"
    elif [[ "$vps_spec" =~ ^\[([^]]+)\]$ ]]; then
        vps_host="${BASH_REMATCH[1]}"
    elif [[ "$vps_spec" == *:* && "$vps_spec" != *:*:* ]]; then
        vps_host="${vps_spec%:*}"
        vps_port="${vps_spec##*:}"
    else
        vps_host="$vps_spec"
    fi

    [[ -n "$vps_host" ]] || die "Invalid VPS host: ${vps_spec}"
    validate_port "VPS SSH port" "$vps_port"
    validate_port "Remote port" "$remote_port"
    [[ "$service_name" =~ ^[A-Za-z0-9._-]+$ ]] || die "Invalid service name: ${service_name}"

    if [[ -z "$key_path" ]]; then
        local pi_home
        pi_home=$(getent passwd "$pi_user" | cut -d: -f6)
        [[ -n "$pi_home" && -d "$pi_home" ]] \
            || die "Could not determine home directory for user '${pi_user}'"
        key_path="${pi_home}/.ssh/id_ed25519_vps_tunnel"
    fi
    [[ -f "$key_path" ]] \
        || die "Tunnel key not found at ${key_path}. Generate it with ssh-keygen and authorize it on the VPS first."

    local local_port
    local unit_file
    local_port=$(detect_local_sshd_port)
    unit_file="/etc/systemd/system/${service_name}.service"

    cat > "$unit_file" <<EOF
# Managed by https://github.com/ymattw/profiles/blob/master/ssh/persist-tunnel.sh
[Unit]
Description=Persistent Reverse SSH Tunnel to VPS (${vps_host}:${vps_port})
After=network-online.target
Wants=network-online.target
StartLimitIntervalSec=0

[Service]
User=${pi_user}
NoNewPrivileges=yes
ExecStart=/usr/bin/ssh -NT \\
  -F /dev/null \\
  -o User=${tunnel_user} \\
  -o Port=${vps_port} \\
  -o BatchMode=yes \\
  -o IdentitiesOnly=yes \\
  -o IdentityFile=${key_path} \\
  -o ConnectTimeout=15 \\
  -o ServerAliveInterval=30 \\
  -o ServerAliveCountMax=3 \\
  -o ExitOnForwardFailure=yes \\
  -o StrictHostKeyChecking=accept-new \\
  -R ${remote_port}:127.0.0.1:${local_port} \\
  ${vps_host}
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF

    chmod 644 "$unit_file"
    systemctl daemon-reload
    systemctl enable --now "${service_name}"

    echo "Installed and started ${unit_file} (local sshd port: ${local_port})."
    systemctl --no-pager -n 10 status "${service_name}" || true
}

main "$@"
