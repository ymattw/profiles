#!/bin/bash

set -o errexit

SELF_DIR=$(cd $(dirname $0) && pwd) || exit 1
cd $SELF_DIR

if [[ -n $1 ]]; then
    echo "Copying zsh/bash profile from $HOME to remote $1..."
    (cd && rsync -az --exclude '.git' .zsh-completions .zshrc .bashrc $1:)
else
    echo "Initializing zsh-completions to $HOME..."
    [[ -d ~/.zsh-completions ]] || {
        git clone https://github.com/zsh-users/zsh-completions.git ~/.zsh-completions
    }
    cp zshrc ~/.zshrc
    cp bashrc ~/.bashrc
fi
