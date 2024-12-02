#!/bin/bash

set -o errexit
set -o nounset

readonly SELF_DIR=$(cd $(dirname $0) && pwd)

mkdir -p ~/.config/nvim
rsync -a --exclude install.sh $SELF_DIR/ ~/.config/nvim/
