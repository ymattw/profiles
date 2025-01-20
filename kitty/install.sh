#!/bin/bash

set -o errexit
set -o nounset

readonly SELF_DIR=$(cd $(dirname $0) && pwd)

[[ $(uname -s) == Darwin ]] || {
    echo "Skipped (not on macOS)"
    exit 0
}

mkdir -p ~/.config/kitty
cp -a $SELF_DIR/kitty.conf ~/.config/kitty/
