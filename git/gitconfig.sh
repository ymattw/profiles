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
git config --global alias.ff "merge --ff-only"
git config --global alias.noff "merge --no-ff"
git config --global alias.tr "branch --set-upstream-to"

# Convert git ssh url to clickable hyperlink
git config --global alias.url \
    "!git remote -v | awk '{print \$2}' | sort -u \
    | sed -e 's,\(git@\|.*//\|\.git$\),,g' -e 's,:,/,'"

git config --global core.editor vim
git config --global color.ui true
git config --global log.abbrevcommit true
git config --global log.decorate short
git config --global diff.noprefix true
git config --global mergetool.vi.cmd 'vimdiff "$LOCAL" "$MERGED" "$REMOTE"'
git config --global push.default simple

# Leave user.name as per repo setting
# Leave user.email as per repo setting
