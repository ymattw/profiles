#!/bin/bash

set -o errexit
set -o nounset

readonly SELF_DIR=$(cd $(dirname $0) && pwd)

if [[ $OSTYPE == darwin* ]]; then
    mkdir -p $HOME/Library/Rime
    cp $SELF_DIR/squirrel.custom.yaml $HOME/Library/Rime/
fi
