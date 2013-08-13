#!/bin/bash

set -o errexit

SELF_DIR=$(cd $(dirname $0) && pwd) || exit 1
cd $SELF_DIR

if [[ -n $1 ]]; then
    echo "Copying zsh profile from $HOME to remote $1..."
    (cd && rsync -az --exclude '.git' .zsh-completions .zshrc $1:)
else
    echo "Initializing zsh-completions to $HOME..."
    [[ -d ~/.zsh-completions ]] || {
        git clone --branch y \
            git://github.com/ymattw/zsh-completions.git ~/.zsh-completions
    }
    (cd ~/.zsh-completions && git pull)
    cp zshrc ~/.zshrc
fi
