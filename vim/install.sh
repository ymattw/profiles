#!/bin/bash

set -o errexit
set -o nounset

readonly SELF_DIR=$(cd $(dirname $0) && pwd)

rsync $SELF_DIR/vimrc ~/.vimrc

[[ -f ~/.vim/autoload/plug.vim ]] || {
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
}

readonly LOG_FILE="/tmp/vim-plug-install-$$.log"
trap "rm -f $LOG_FILE" EXIT
vim +PlugInstall +qall >& $LOG_FILE
