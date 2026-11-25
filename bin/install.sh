#!/bin/bash

set -o errexit
set -o nounset

readonly SELF_DIR=$(cd $(dirname $0) && pwd)

mkdir -p ~/bin
rsync -a --exclude install.sh --exclude README.md $SELF_DIR/ ~/bin/

[[ $OSTYPE == darwin* ]] || exit 0
[[ -f /usr/local/bin/gnubby-ssh ]] || exit 0

# Workaround to bypass ssh wrappers on corp laptop.
ln -sf ssh-wrapper ~/bin/ssh
ln -sf ssh-wrapper ~/bin/scp
ln -sf ssh-wrapper ~/bin/sftp
