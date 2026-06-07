#!/bin/bash

set -o errexit
set -o nounset

readonly SELF_DIR=$(cd $(dirname $0) && pwd)

[[ $OSTYPE == darwin* ]] || {
    echo "Skipped (not on macOS)"
    exit 0
}

mkdir -p ~/.config/neovide
cp -a $SELF_DIR/*.toml ~/.config/neovide/
