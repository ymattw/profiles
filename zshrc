# Matthew Wang's zsh profile for general Linux/Unix
#

# Customized PATH
#
PATH=/usr/bin:/bin:/usr/sbin:/sbin
[[ ! -d /opt/local/bin ]] || PATH=/opt/local/bin:$PATH
PATH=/usr/local/bin:/usr/local/sbin:$PATH

# Load RVM if installed, otherwise load ChefDK if installed
if [[ -x $HOME/.rvm/bin/rvm ]] && [[ -s "$HOME/.rvm/scripts/rvm" ]]; then
    PATH=$HOME/.rvm/bin:$PATH
    unset GEM_HOME GEM_PATH GEM_ROOT
    source "$HOME/.rvm/scripts/rvm"
elif [[ -x /usr/bin/chef ]]; then
    eval "$(/usr/bin/chef shell-init sh)"
fi

# ~/bin takes precedence
[[ ! -d $HOME/bin ]] || PATH=$HOME/bin:$PATH

export PATH

# Useful options
#
setopt prompt_subst
setopt interactive_comments
setopt nocase_glob
setopt nocase_match 2>/dev/null     # does not work for zsh < 4.3
setopt extended_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_ignore_space
setopt hist_find_no_dups
setopt hist_verify
setopt share_history
setopt auto_pushd
setopt pushd_ignore_dups
unsetopt nomatch
unsetopt correct
unsetopt auto_remove_slash
bindkey -e                          # Reclaim C-a, C-e, C-r, M-., etc.
! [[ -o login ]] || stty stop undef # Make 'C-s' to do fwd-i-search
bindkey "^U" backward-kill-line     # Keep the same behavior as in bash

# Useful environments. Locale (LC_*) matters for ls and sort on Linux, see also
# www.gnu.org/software/coreutils/faq/#Sort-does-not-sort-in-normal-order_0021
#
export HISTFILE=~/.zhistory         # Prevent from ~/.zsh<tab> completion
export HISTSIZE=10000
export SAVEHIST=10000
export EDITOR=vim
if [[ $(uname -s) == Linux ]]; then
    export LC_COLLATE=C
fi

# Load completions
#
[[ ! -d ~/.zsh-completions ]] || fpath=(~/.zsh-completions/src $fpath)
autoload -U compinit && compinit
zstyle ':completion:*' menu yes select
zstyle ':completion:*' users off
zmodload zsh/complist
bindkey -M menuselect '^M' .accept-line     # <Enter> only once to accept
ZLE_REMOVE_SUFFIX_CHARS=                    # no space after, see zshparam(1)

# Fix default host completion
__hosts=($(sed -ne 's/[, ].*//p' ~/.ssh/known_hosts* 2>/dev/null))
zstyle ':completion:*:hosts' hosts $__hosts

# Customized theme (prompt)
#
_DR=$'%{\e[31m%}'       # red
_DG=$'%{\e[32m%}'       # green
_DY=$'%{\e[33m%}'       # yellow
_DB=$'%{\e[34m%}'       # blue
_DM=$'%{\e[35m%}'       # magenta
_DC=$'%{\e[36m%}'       # cyan
_RV=$'%{\e[7m%}'        # reverse
_NC=$'%{\e[0m%}'        # reset color

function __git_active_branch() {
    if [[ $(git rev-parse --is-inside-work-tree 2>/dev/null) == true ]]; then
        local branch info age track
        branch=$(git symbolic-ref HEAD 2>/dev/null)
        branch=${branch#refs/heads/}
        info=$(git status -s 2>/dev/null)
        age=$(git log --pretty=format:'%cr' -1 refs/heads/$branch 2>/dev/null)
        track=$(git status -sb 2>/dev/null | sed -n 's/^##.*\[\(.*\)\].*/, \1/p')

        # FIXME: $_DR and $_DG won't expand here
        if [[ -z $info ]]; then
            print -nP "%{\e[32m%} ($branch) %{\e[36m%}[${age}${track}]"
        elif [[ -z $(echo "$info" | grep -v '^??') ]]; then
            print -nP "%{\e[35m%} ($branch) %{\e[36m%}[${age}${track}]"
        else
            print -nP "%{\e[31m%} ($branch) %{\e[36m%}[${age}${track}]"
        fi
    fi
}

# Fancy PROMPT, prompt exit status of last command, currenet time, hostname,
# time, cwd, git status and branch, also prompt the '%' in reverse color when
# we have background jobs.
#
PROMPT="\$([[ \$? == 0 ]] && echo '${_DG}✔' || echo '${_DR}✘') %* "

# Detect whether this box has my own ssh key (~/.ssh/$USER.key), distinguish
# hostname color and setup ssh-agent related environment accordingly
#
if [[ -f ~/.ssh/$USER.key ]]; then
    # I am on my own machine, try load ssh-agent related environments
    PROMPT+="${_DB}"                                # blue hostname
    _MY_AGENT_RC=~/.ssh-agent.rc
    [[ ! -f $_MY_AGENT_RC ]] || source $_MY_AGENT_RC
    if ! ps -p ${SSH_AGENT_PID:-0} 2>/dev/null | grep -q ssh-agent; then
        print -P "${_DR}Starting new ssh-agent process${_NC}" >&2
        rm -f ~/.ssh-agent.sock
        ssh-agent -s -a ~/.ssh-agent.sock | sed '/^echo/d' > $_MY_AGENT_RC
        source $_MY_AGENT_RC
    fi
    ssh-add -L | grep -qw $USER.key || ssh-add ~/.ssh/$USER.key
else
    # Otherwise assume I am on other's box, highlight hostname in magenta
    PROMPT+="${_DM}"                                # magenta hostname
fi

# Highlight hostname in reverse green if inside a container
[[ -z $container_uuid ]] || PROMPT+="${_RV}${_DG}"
PROMPT+="$(hostname -f)"
PROMPT+="${_NC}:${_DY}%~${_NC}"                     # yellow cwd
PROMPT+='$(__git_active_branch)'                    # colorful git branch name
PROMPT+=" ${_DC}"$'⤾\n'                             # cyan wrap char, newline
PROMPT+="\$([[ -z \$(jobs) ]] || echo '${_RV}')"    # reverse bg job indicator
PROMPT+="%#${_NC} "                                 # % or #
unset _DR _DG _DY _DB _DM _DC _RV _NC

# Shortcuts (Aliases, function, auto completion etc.)
#
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias pd='popd'
! type vim >& /dev/null || alias vi='vim -Xn'
alias grep='grep --color=auto'

case $(uname -s) in
    Linux)
        alias ls='/bin/ls -F --color=auto'
        alias l='/bin/ls -lF --color=auto'
        alias lsps='ps -ef f | grep -vw grep | grep -i'
        ;;
    Darwin)
        alias ls='/bin/ls -F'
        alias l='/bin/ls -lF'
        alias lsps='ps -ax -o user,pid,ppid,stime,tty,time,command | grep -vw grep | grep -i'
        ;;
    *)
        alias ls='/bin/ls -F'
        alias l='/bin/ls -lF'
        alias lsps='ps -auf | grep -vw grep | grep -i'
        ;;
esac

# Utilities
#
# Find a file which name matches given pattern (ERE, case insensitive)
function f() {
    local pat=${1?'Usage: f ERE-pattern [path...]'}
    shift
    find ${@:-.} \( -path '*/.svn' -o -path '*/.git' -o -path '*/.idea' \) \
        -prune -o -print -follow | grep -iE "$pat"
}

# Load file list generated by function f() above in vim, you can type 'gf' to
# jump to the file
#
function vif() {
    local tmpf=/tmp/viftmpfile.$RANDOM$$
    f "$@" > $tmpf && vi -c "/$1" $tmpf && rm -f $tmpf
}

# Grep a ERE pattern in cwd or given path
function g() {
    local string_pat=${1:?"Usage: g ERE-pattern [grep opts] [path...]"}
    shift
    local grep_opts="--color=auto"
    local paths

    while (( $# > 0 )); do
        case "$1" in
            -*) grep_opts="$grep_opts $1"; shift;;
            *) paths="$paths $1"; shift;;
        esac
    done
    paths=${paths# }
    grep_opts=${grep_opts# }
    [[ -n "$paths" ]] || paths="."

    find $paths \( -path '*/.svn' -o -path '*/.git' -o -path '*/.idea' \) \
        -prune -o -type f -print0 -follow \
        | eval "xargs -0 -P128 grep -EH $grep_opts '$string_pat'"
}

# vim:set et sts=4 sw=4 ft=zsh:
