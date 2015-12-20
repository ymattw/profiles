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
    [[ -f ~/.vim/autoload/plug.vim ]] || {
        curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
            https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    }
    vim +PlugInstall +qall
fi
