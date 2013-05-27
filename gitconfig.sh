#!/bin/bash

git config --global alias.st status
git config --global alias.ci commit
git config --global alias.info "remote -v show -n"
git config --global alias.br branch
git config --global alias.co checkout
git config --global alias.ls "log --oneline --decorate --graph"
git config --global alias.tail "log --oneline --decorate --graph -10"
git config --global alias.pick cherry-pick
git config --global alias.up "pull --rebase"
git config --global core.editor vim
git config --global color.ui true
git config --global log.abbrevcommit true
git config --global log.decorate short

: git config --global user.email ?
: git config --global user.name ?
