#!/bin/bash

git config --global alias.st status
git config --global alias.ci commit
git config --global alias.info "remote -v show -n"
git config --global alias.vi "difftool -y -x vimdiff"
git config --global alias.mt "mergetool -y --tool vi"
git config --global alias.br branch
git config --global alias.co checkout
git config --global alias.ls "log --decorate --name-status"
git config --global alias.hist "log --oneline --decorate --graph"
git config --global alias.tail "log --oneline --decorate --graph -10"
git config --global alias.loggrep "log --decorate --all-match -i --grep"
git config --global alias.pick cherry-pick
git config --global alias.rb "rebase -p"
git config --global alias.up "pull --rebase"
git config --global alias.pl "pull --rebase upstream"
git config --global alias.pu "push upstream"
git config --global alias.ff "merge --ff-only"
git config --global alias.noff "merge --no-ff"
git config --global alias.pp \
        '!fn() {
            git pull --rebase ${1?} ${2?} && git push $1 $2
        }; fn'
git config --global alias.tr \
        '!fn() {
            b=$(git symbolic-ref HEAD) &&
            git branch --set-upstream ${b#refs/heads/} ${1?}
        }; fn'

git config --global core.editor vim
git config --global color.ui true
git config --global log.abbrevcommit true
git config --global log.decorate short
git config --global mergetool.vi.cmd 'vimdiff "$LOCAL" "$MERGED" "$REMOTE"'

: git config --global user.email ?
: git config --global user.name ?
