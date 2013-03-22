#!/bin/bash

set -x
git config --global alias.st status
git config --global alias.ci commit
git config --global alias.info "remote -v"
git config --global alias.br branch
git config --global alias.co checkout
git config --global alias.hist "log --format=oneline --graph"
git config --global core.editor vim
git config --global color.ui true
git config --global log.abbrevcommit true
git config --global log.decorate short

: git config --global user.email ?
: git config --global user.name ?
