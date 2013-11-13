# Matthew Wang's zsh profile for general Linux/Unix with a little Y! flavor
#

# Customized PATH
#
function path_prepend() {
    local x
    for x in "$@"; do
        [[ :$PATH: == *:$x:* ]] || PATH=$x:$PATH
    done
}
path_prepend /bin /usr/bin /sbin /usr/sbin /usr/local/bin /usr/local/sbin ~/bin
[[ ! -d /opt/local/bin ]] || path_prepend /opt/local/bin
[[ ! -d /home/y/bin64 ]] || path_prepend /home/y/bin64
[[ ! -d /home/y/bin ]] || path_prepend /home/y/bin
unset path_prepend
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
unsetopt nomatch
unsetopt correct
unsetopt auto_remove_slash
bindkey -e                          # Reclaim C-a, C-e, C-r, M-., etc.
stty stop undef                     # Make 'C-s' to do fwd-i-search
bindkey "^U" backward-kill-line     # Keep the same behavior as in bash

# Useful environments. Locale (LC_*) matters for ls and sort on Linux, see also
# www.gnu.org/software/coreutils/faq/#Sort-does-not-sort-in-normal-order_0021
#
export HISTFILE=~/.zhistory         # Prevent from ~/.zsh<tab> completion
export HISTSIZE=10000
export SAVEHIST=10000
export EDITOR=vim
export GREP_OPTIONS="--color=auto"
export LESS="-XFR"
if [[ $(uname -s) == Linux ]]; then
    export LC_COLLATE=C
    export LC_CTYPE=C
fi

# Load completions
#
[[ ! -d ~/.zsh-completions ]] || fpath=(~/.zsh-completions/src $fpath)
autoload -U compinit && compinit
zstyle ':completion:*' menu yes select
zstyle ':completion:*' users off
zmodload zsh/complist
bindkey -M menuselect '^M' .accept-line     # <Enter> only once to accept
ZLE_REMOVE_SUFFIX_CHARS=$' \t\n;&|*?$'      # no space after, see zshparam(1)

# Fix default host completion
__hosts=($(sed -ne 's/[, ].*//p' ~/.ssh/known_hosts* 2>/dev/null))
zstyle ':completion:*:hosts' hosts $__hosts

# Customized yroot completion for Y! boxes
#
if [[ $(hostname -f) == *.yahoo.* ]]; then
    function _yroot_complete() {
        local d="/home/y/var/yroots"
        reply=($(/bin/ls $d/*.conf |& sed -n "s#$d/\(.*\).conf#\1#p"))
    }
    compctl -K _yroot_complete yroot
fi

# Customized theme (prompt)
#
_LR=$'%{\e[1;31m%}'     # light red
_LG=$'%{\e[1;32m%}'     # light green
_LY=$'%{\e[1;33m%}'     # light yellow
_LB=$'%{\e[1;34m%}'     # light blue
_LM=$'%{\e[1;35m%}'     # light magenta
_LC=$'%{\e[1;36m%}'     # light cyan
_RV=$'%{\e[7m%}'        # reverse
_NC=$'%{\e[0m%}'        # reset color

function __git_active_branch() {
    if [[ $(git rev-parse --is-inside-work-tree 2>/dev/null) == true ]]; then
        local branch info age track
        branch=$(git symbolic-ref HEAD 2>/dev/null)
        branch=${branch##refs/heads/}
        info=$(git status -s 2>/dev/null)
        age=$(git log --pretty=format:'%cr' -1 refs/heads/$branch 2>/dev/null)
        track=$(git status -sb 2>/dev/null | sed -n 's/^##.*\[\(.*\)\].*/, \1/p')

        # FIXME: $_LR and $_LG won't expand here
        if [[ -z $info ]]; then
            print -nP "%{\e[1;32m%} ($branch) %{\e[1;36m%}[${age}${track}]"
        elif [[ -z $(echo "$info" | grep -v '^??') ]]; then
            print -nP "%{\e[1;35m%} ($branch) %{\e[1;36m%}[${age}${track}]"
        else
            print -nP "%{\e[1;31m%} ($branch) %{\e[1;36m%}[${age}${track}]"
        fi
    fi
}

# Fancy PROMPT, prompt exit status of last command, currenet time, hostname,
# yroot, time, cwd, git status and branch, also prompt the '%' in reverse color
# when we have background jobs.
#
PROMPT="\$([[ \$? == 0 ]] && echo '${_LG}✔' || echo '${_LR}✘') %* "

# Promopt username only when user switched (happens after sudo -s -u <user>)
if [[ $(logname 2>/dev/null) != $(id -un) ]] || [[ $USER != $(id -un) ]]; then
    PROMPT+="${_LR}$(id -un)${_NC}@"
fi

# Tip: start a global ssh-agent for yourself, for example, add this in
# /etc/rc.d/rc.local (RHEL):
#   U=ymattw
#   rm -f /home/$U/.ssh-agent.sock
#   /bin/su -m $U -c "/usr/bin/ssh-agent -s -a /home/$U/.ssh-agent.sock \
#      | sed '/^echo/d' > /home/$U/.ssh-agent.rc"
# You will need to ssh-add your identity manually once
#
if [[ -f ~/.ssh-agent.rc ]]; then
    # I am on my own machine, try load ssh-agent related environments
    PROMPT+="${_LB}"                                # blue hostname
    source ~/.ssh-agent.rc
    if ps -p ${SSH_AGENT_PID:-0} >& /dev/null; then
        if ! ssh-add -L | grep -q ^ssh-; then
            print -P "${_LR}Warning: No key is being held by ssh-agent," \
                     "try 'ssh-add <your-ssh-private-key>'${_NC}" >&2
        fi
    else
        print -P "${_LR}Warning: No global ssh-agent process alive${_NC}" >&2
    fi
else
    # Otherwise assume I am on other's box, highlight hostname in magenta
    PROMPT+="${_LM}"                                # magenta hostname
fi

PROMPT+="$(_H=$(hostname -f); echo ${_H%.yahoo.*})"
PROMPT+="${_LG}"                                    # then green {yroot}
PROMPT+=${YROOT_NAME+"{$YROOT_NAME}"}
PROMPT+=" ${_LY}%~${_NC}"                           # yellow cwd
PROMPT+='$(__git_active_branch)'                    # colorful git branch name
PROMPT+=" ${_LC}"$'⤾\n'                             # cyan wrap char, newline
PROMPT+="\$([[ -z \$(jobs) ]] || echo '${_RV}')"    # reverse bg job indicator
PROMPT+="%#${_NC} "                                 # % or #
unset _LR _LG _LY _LB _LM _LC _RV _NC

# Shortcuts (Aliases, function, auto completion etc.)
#
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias 1='cd -'
alias 2='cd -2'
alias 3='cd -3'
alias 4='cd -4'
alias vi='vim -Xn'

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
    local tmpf=$(mktemp)
    f "$@" > $tmpf && vi -c "/$1" $tmpf && rm -f $tmpf
}

# Grep a ERE pattern in files that match given file glob in cwd or given path
function g() {
    local string_pat=${1:?"Usage: g ERE-pattern [file-glob] [grep opts] [path...]"}
    shift
    local file_glob grep_opts paths

    while (( $# > 0 )); do
        case "$1" in
            *\**|*\?*|*\]*) file_glob="$1"; shift;;
            -*) grep_opts="$grep_opts $1"; shift;;
            *) paths="$paths $1"; shift;;
        esac
    done
    paths=${paths# }
    grep_opts=${grep_opts# }
    [[ -n "$file_glob" ]] || file_glob="*"
    [[ -n "$paths" ]] || paths="."

    find $paths \( -path '*/.svn' -o -path '*/.git' -o -path '*/.idea' \) \
        -prune -o -type f -name "$file_glob" -print0 -follow \
        | xargs -0 -P128 grep -EH $grep_opts "$string_pat"
}

# vim:set et sts=4 sw=4 ft=zsh:
