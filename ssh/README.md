# Remote Access to Home Lab (Pi & Mac mini) via VPS Jump Box

Reach home-LAN hosts (`pi` and `mini`) from a locked-down `corp-laptop` over
standard OpenSSH while keeping corporate and personal SSH keys isolated.

## Files in This Directory

| File                | Runs On       | Purpose                                                                                                           |
| ------------------- | ------------- | ----------------------------------------------------------------------------------------------------------------- |
| `setup-tunnel.sh`   | `vps`         | Creates the locked-down `tunnel` user, authorizes the Pi's tunnel key, and configures, reloads & verifies `sshd`. |
| `persist-tunnel.sh` | `pi`          | Installs and starts the `reverse-ssh-tunnel` `systemd` service.                                                   |
| `config.sample`     | `corp-laptop` | Ready-to-adapt `~/.ssh/config` template separating personal/home-lab hosts from corp hosts.                       |
| `install.sh`        | `corp-laptop` | Ensures `~/.ssh` (`0700`) exists and syncs `config.sample` into `~/.ssh/` (used by `./install.sh ssh`).           |

## 1. Situation & Constraints

- **Home network (behind NAT/ISP):**
  - **Raspberry Pi (`pi`):** Always-on server with a webcam attached; runs
    Tailscale so mobile phones on the same tailnet can view the webcam.
  - **Mac mini (`mini`):** On the same home LAN as the Pi.
- **Public VPS (`vps`):**
  - Resource-constrained, so no Tailscale or WireGuard is installed.
  - Also serves as a personal dev box that needs SSH access to personal GitHub
    repositories.
- **Work laptop (`corp-laptop`):**
  - Cannot install Tailscale or WireGuard, but outbound SSH to external servers
    is allowed.
  - Corp SSH keys are dynamic (security-key backed / managed by corp tooling)
    and live in the default `$SSH_AUTH_SOCK`.
  - Personal SSH key is a passphrase-encrypted `ed25519` key
    (`~/.ssh/$USER.key`).
  - **Hard security requirement:** Corp keys must never be exposed, offered, or
    forwarded to the VPS or the public internet.

## 2. Architecture & Design Choices

```text
corp-laptop ──(SSH #1)──▶ vps ◀──(persistent reverse tunnel :2222)── pi ──(LAN :22)──▶ mini
     │                                                               ▲                  ▲
     ├─────────────────────(SSH #2, end-to-end)──────────────────────┘                  │
     └─────────────────────(SSH #3, end-to-end)─────────────────────────────────────────┘
```

1. **Persistent reverse SSH tunnel (`pi` → `vps`):** Uses only standard OpenSSH
   (a few MB of RAM on the VPS) and binds strictly to loopback on the VPS under
   a locked-down `/bin/false` user.
2. **Chained `ProxyJump` (`corp-laptop` → `vps` → `pi` → `mini`):** Every hop
   authenticates end-to-end from `corp-laptop`. No personal private keys sit on
   the VPS or Pi, and `ForwardAgent` stays off (`no`, the default) for both `pi`
   and `mini`.
3. **Isolated personal `ssh-agent` socket (`~/.ssh/agent.sock`):** OpenSSH
   cannot filter dynamically loaded corp keys per host within a single shared
   `ssh-agent`. Keeping the personal `ed25519` key in a dedicated, unexported
   `ssh-agent` socket leaves the corp `$SSH_AUTH_SOCK` untouched while allowing
   safe `ForwardAgent ~/.ssh/agent.sock` to `vps` for personal GitHub access.

## 3. Reverse SSH Tunnel Setup (Pi & VPS)

Both setup scripts assume **Debian 12+** or **Ubuntu 22.04+**.

### 3.1 Generate the Dedicated Tunnel Key on `pi`

Generate a passphrase-free `ed25519` key dedicated solely to bringing up the
tunnel after unattended reboots:

```bash
ssh-keygen -t ed25519 -N "" -C "pi-reverse-tunnel" -f ~/.ssh/id_ed25519_vps_tunnel
```

### 3.2 Configure the Locked-Down `tunnel` User on `vps`

Copy `setup-tunnel.sh` to the VPS and pass the Pi's public key file (or pipe it
on stdin):

```bash
sudo ./setup-tunnel.sh /tmp/id_ed25519_vps_tunnel.pub
# or:
cat id_ed25519_vps_tunnel.pub | sudo ./setup-tunnel.sh
```

What the script does:

- Creates a system user `tunnel` with `/bin/false` and adds the public key
  idempotently to `/home/tunnel/.ssh/authorized_keys` (`0600`).
- Writes `/etc/ssh/sshd_config.d/99-reverse-tunnel-tunnel.conf`:

  ```sshconfig
  Match User tunnel
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
  ```

- Validates with `sshd -t` (rolling back automatically on error), reloads `ssh`,
  and verifies the effective settings via `sshd -T -C user=tunnel`.

> **Note:** Your normal `<VPS_USER>` on `vps` and `<PI_USER>` on `pi` must keep
> `AllowTcpForwarding yes` (the OpenSSH default) so `ProxyJump` (`ssh -W`) can
> forward TCP streams.

### 3.3 Persist the Tunnel on `pi` with `systemd`

Back on the Pi, install, enable, and start `reverse-ssh-tunnel.service` under
`/etc/systemd/system/` (auto-detects the local `sshd` port):

```bash
# Usage: sudo ./persist-tunnel.sh <vps[:port]> <remotePort>
sudo ./persist-tunnel.sh <VPS_IP> 2222
```

Verify on **`vps`** that port `2222` is listening on loopback only:

```bash
ss -tln | grep ':2222\b'
# Expected: LISTEN ... 127.0.0.1:2222 0.0.0.0:*
```

**Why the `systemd` unit options matter:**

- `-F /dev/null`, `IdentitiesOnly=yes`, and `IdentityFile`: Prevents any
  personal `~/.ssh/config` or other keys on the Pi from interfering with the
  service.
- `ExitOnForwardFailure=yes`: If the VPS still briefly holds the port from a
  stale session, `ssh` exits immediately so `systemd` retries 10s later instead
  of hanging without a working forward.
- `ServerAliveInterval=30` + `ClientAliveInterval 30` (`CountMax 3`): Both
  sides detect silent ISP drops within ~90s.
- `StartLimitIntervalSec=0` (in `[Unit]`): Prevents `systemd` from giving up
  during multi-hour ISP outages.
- `BatchMode=yes` + `StrictHostKeyChecking=accept-new`: Never blocks on
  interactive prompts while pinning the VPS host key on first connect.

## 4. Isolated Personal `ssh-agent` (`zsh/zshrc` & `bash/bashrc`)

Both `../zsh/zshrc` and `../bash/bashrc` include `__setup_ssh_agent`, which
starts a dedicated personal `ssh-agent` at `~/.ssh/agent.sock` without modifying
the global `$SSH_AUTH_SOCK`. The personal key is unlocked lazily on first `ssh`
via `AddKeysToAgent` in `~/.ssh/config`. It works identically on both personal
hosts and `corp-laptop`, and no-ops cleanly if `~/.ssh/$USER.key` is absent.

## 5. `~/.ssh/config` Setup on `corp-laptop`

Install the sample config via `./install.sh ssh` from the repo root (syncs
`config.sample` into `~/.ssh/config.sample`), then copy or merge it into
`~/.ssh/config` (`chmod 600 ~/.ssh/config`) and fill in the `<...>`
placeholders. See [`config.sample`](config.sample) for the full template.

### Key Gotchas

- **Keep specific `Host` blocks above broader blocks** and **`Host *` at the
  bottom** (first match wins for single-value directives).
- **Never put corp `IdentityFile` directives inside `Host *`:** `IdentityFile`
  accumulates across all matching blocks; keep corp keys scoped strictly to
  corp host patterns.
- **Never pass `-A` on the command line** (`ssh -A vps`): `-A` sets
  `ForwardAgent yes`, which overrides `ForwardAgent ~/.ssh/agent.sock` and
  forwards the default corp `$SSH_AUTH_SOCK` instead.

### Common Usage

```bash
# Dev session on VPS (personal GitHub works via isolated personal agent)
ssh vps

# Jump directly to Pi (corp-laptop -> vps -> pi)
ssh pi

# Jump directly to Mac mini (corp-laptop -> vps -> pi -> mini)
ssh mini

# Mac mini Screen Sharing (VNC) on demand -> connect VNC client to localhost:5900
ssh -L 5900:localhost:5900 mini

# Ad-hoc SOCKS5 proxy into home LAN (e.g., Pi webcam UI)
ssh -D 1080 pi
```

## 6. Verification Tips

1. **Local agent isolation on `corp-laptop`:**

   ```bash
   ssh-add -l                                  # Only corp keys
   SSH_AUTH_SOCK=~/.ssh/agent.sock ssh-add -l  # Only personal key
   ```

2. **Effective `~/.ssh/config` check:**

   ```bash
   ssh -G vps | grep -E '^(identityagent|identitiesonly|forwardagent) '
   ssh -G pi  | grep -E '^(identityagent|identitiesonly|forwardagent|proxyjump) '
   ```

3. **No corp public keys offered to `vps`:**

   ```bash
   ssh -v vps 2>&1 | grep "Offering public key"        # Only personal key
   ```

4. **Forwarded agent on `vps` contains only personal key & reaches GitHub:**

   ```bash
   # Inside `ssh vps`:
   ssh-add -l             # Only personal key, zero corp keys
   ssh -T git@github.com  # Authenticates as your personal GitHub account
   ```

5. **No agent forwarded to `pi` or `mini`:**

   ```bash
   # Inside `ssh pi` or `ssh mini`:
   echo "$SSH_AUTH_SOCK"  # Empty
   ```

6. **Tunnel health & logs on `pi`:**

   ```bash
   sudo systemctl status reverse-ssh-tunnel
   journalctl -u reverse-ssh-tunnel -n 50 --no-pager
   ```
