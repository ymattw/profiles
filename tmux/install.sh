#!/bin/bash

set -o errexit
set -o nounset

readonly SELF_DIR=$(cd $(dirname $0) && pwd)

rsync $SELF_DIR/tmux.conf ~/.tmux.conf
mkdir -p ~/.config/karabiner
cp karabiner.json ~/.config/karabiner/karabiner.json
