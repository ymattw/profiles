#!/bin/bash

set -o errexit

SELF_DIR=$(cd $(dirname $0) && pwd) || exit 1
cd $SELF_DIR

if [[ -n $1 ]]; then
    echo "Copying zsh profile from $HOME to remote $1..."
    (cd && rsync -az --exclude '.git' .oh-my-zsh .zshrc $1:)
else
    echo "Initializing oh-my-zsh to $HOME..."
    [[ -d ~/.oh-my-zsh ]] || {
        git clone git://github.com/ymattw/oh-my-zsh.git ~/.oh-my-zsh
    }
    cp zshrc ~/.zshrc
fi
