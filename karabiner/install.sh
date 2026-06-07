#!/bin/bash

set -o errexit
set -o nounset

readonly SELF_DIR=$(cd $(dirname $0) && pwd)

if [[ $OSTYPE == darwin* ]]; then
    mkdir -p ~/.config/karabiner
    cp $SELF_DIR/karabiner.json ~/.config/karabiner/karabiner.json
fi
