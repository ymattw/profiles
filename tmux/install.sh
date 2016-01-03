#!/bin/bash

set -o errexit
set -o nounset

readonly SELF_DIR=$(cd $(dirname $0) && pwd)

cp $SELF_DIR/tmux.conf ~/.tmux.conf

echo "Tip: see $SELF_DIR/seil-tmux.sh if you want to re-map Caps Lock to F8" \
     "and use it for tmux prefix key on OS X"
