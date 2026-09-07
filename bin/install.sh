#!/bin/bash

set -o errexit
set -o nounset

readonly SELF_DIR=$(cd $(dirname $0) && pwd)

mkdir -p ~/bin
rsync -a --exclude install.sh --exclude README.md $SELF_DIR/ ~/bin/

[[ $OSTYPE == darwin* ]] || exit 0
[[ $(hostname) == *.roam.internal ]] || exit 0

# Workaround to bypass ssh wrappers on corp laptop.

cat > ~/bin/ssh << "EOF"
#!/bin/bash
# Use /usr/local/bin/ssh* for cloudtop machines, use defaults otherwise.

if echo "$*" | grep -qE "^w.l|oog..rs.com"; then
    /usr/local/bin/$(basename $0) -o PubkeyAcceptedAlgorithms=ecdsa-sha2-nistp256-cert-v01@openssh.com "$@"
else
    /usr//bin/$(basename $0) -o PubkeyAcceptedAlgorithms=ssh-ed25519 "$@"
fi
EOF

chmod +x ~/bin/ssh
ln -sf ssh ~/bin/scp
ln -sf ssh ~/bin/sftp
ln -sf ssh ~/bin/ssh-agent
ln -sf ssh ~/bin/ssh-keygen
