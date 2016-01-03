#!/bin/bash

set -o errexit
set -o nounset

readonly SELF_DIR=$(cd $(dirname $0) && pwd)
readonly BACKUP_DIR=~/.bash.backup.$(date '+%F-%H%M%S')
readonly BASH_FILES=(~/.bash_profile ~/.bash_login ~/.profile)

mkdir -p $BACKUP_DIR
for x in ${BASH_FILES[@]}; do
    [[ ! -f $x ]] || cp $x $BACKUP_DIR/
done

rm -f ${BASH_FILES[@]}

cp $SELF_DIR/bashrc ~/.bashrc
ln -s ~/.bashrc ~/.bash_profile
