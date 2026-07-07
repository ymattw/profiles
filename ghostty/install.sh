#!/bin/bash

set -o errexit
set -o nounset

readonly SELF_DIR=$(cd $(dirname $0) && pwd)

[[ $OSTYPE == darwin* ]] || {
    echo "Skipped (not on macOS)"
    exit 0
}

mkdir -p ~/.config/ghostty
cp -a $SELF_DIR/config ~/.config/ghostty/

# Ghostty does not currently have a built-in configuration file option to
# disable the alternate screen buffer. However, you can disable it globally at
# the system level by stripping the smcup (enter alt screen) and rmcup (exit
# alt screen) capabilities from Ghostty's terminfo.
infocmp -1x | grep -vE 'rmcup|smcup' | tic -x -
