#!/bin/bash

set -o errexit

SELF_DIR=$(cd $(dirname $0) && pwd) || exit 1
cd $SELF_DIR

if [[ -n $1 ]]; then
    echo "Copying vim profile from $HOME to remote $1..."
    (cd && rsync -az --delete --exclude '.git' .vimrc .vim $1:)
else
    echo "Initializing vim profile to $HOME..."
    cp vimrc ~/.vimrc
    [[ -d ~/.vim/bundle/Vundle.vim ]] || {
        git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim
    }
    vim +PluginInstall +qall
fi
