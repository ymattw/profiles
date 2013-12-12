# Matthew Wang's bash profile for general Linux/Unix with a little Y! flavor
#
# Suggestion: ln -sf .bashrc .bash_profile
#

# Source global definitions
[[ ! -f /etc/profile ]] || . /etc/profile
[[ ! -f /etc/bashrc ]] || . /etc/bashrc

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
bind 'set match-hidden-files off' >& /dev/null  # Don't tab-expand hidden files
stty stop undef                                 # Make 'C-s' to do i-search

# Useful environments. Locale (LC_*) matters for ls and sort on Linux, see also
# www.gnu.org/software/coreutils/faq/#Sort-does-not-sort-in-normal-order_0021
#
export HISTFILE=~/.bash_history     # In case switched from zsh temporally
export HISTSIZE=10000
export EDITOR=vim
export GREP_OPTIONS="--color=auto"
export LESS="-XFR"
if [[ $(uname -s) == Linux ]]; then
    export LC_COLLATE=C
    export LC_CTYPE=C
fi

# Load completions
#
# https://raw.github.com/git/git/master/contrib/completion/git-completion.bash
[[ ! -f ~/.git-completion.bash ]] || . ~/.git-completion.bash

# Auto complete hostnames for hostname related commands, note 'complete -A
# hostname' also works but it does not recognize new $HOSTFILE
#
function _host_complete() {
    local cur=${COMP_WORDS[COMP_CWORD]}
    local hosts=$(sed -ne 's/[, ].*//p' ~/.ssh/known_hosts* 2>/dev/null)
    COMPREPLY=($(compgen -W "$hosts" -- $cur))
}
complete -F _host_complete ssh scp host nc ping telnet

# Auto complete unset from exported variables
complete -A export unset

# Customized yroot completion for Y! boxes
#
if [[ $(hostname -f) == *.yahoo.* ]]; then
    function _yroot_complete() {
        local cur=${COMP_WORDS[COMP_CWORD]}
        local d="/home/y/var/yroots"
        local -a yroots=($(/bin/ls $d/*.conf |& sed -n "s#$d/\(.*\).conf#\1#p"))
        COMPREPLY=($(compgen -W '${yroots[@]}' -- $cur ))
    }
    complete -F _yroot_complete yroot
fi

# Customized theme (prompt)
#
_LR="\[\e[1;31m\]"      # light red
_LG="\[\e[1;32m\]"      # light green
_LY="\[\e[1;33m\]"      # light yellow
_LB="\[\e[1;34m\]"      # light blue
_LM="\[\e[1;35m\]"      # light magenta
_LC="\[\e[1;36m\]"      # light cyan
_RV="\[\e[7m\]"         # reverse
_NC="\[\e[0m\]"         # no color

function __git_status_color() {
    if [[ $(git rev-parse --is-inside-work-tree 2>/dev/null) == true ]]; then
        local info=$(git status -s)
        if [[ -z $info ]]; then
            echo -ne "\033[1;32m"       # clean status
        elif [[ -z $(echo "$info" | grep -v '^??') ]]; then
            echo -ne "\033[1;35m"       # has untracked objects only
        else
            echo -ne "\033[1;31m"       # unclean status
        fi
    fi
}

function __git_active_branch() {
    if [[ $(git rev-parse --is-inside-work-tree 2>/dev/null) == true ]]; then
        local branch=$(git symbolic-ref HEAD 2>/dev/null)
        echo " (${branch##refs/heads/})"
    fi
}

function __git_track_info() {
    if [[ $(git rev-parse --is-inside-work-tree 2>/dev/null) == true ]]; then
        local branch info age track
        branch=$(git symbolic-ref HEAD 2>/dev/null)
        branch=${branch##refs/heads/}
        info=$(git status -s 2>/dev/null)
        age=$(git log --pretty=format:'%cr' -1 refs/heads/$branch 2>/dev/null)
        track=$(git status -sb 2>/dev/null | sed -n 's/^##.*\[\(.*\)\].*/, \1/p')
        echo " [${age}${track}]"
    fi
}

# Fancy PS1, prompt exit status of last command, currenet time, hostname,
# yroot, time, cwd, git status and branch, also prompt the '%' in reverse color
# when we have background jobs. '\[' and '\]' is to mark ansi colors to allow
# shell to calculate prompt string length correctly
#
PS1="\$([[ \$? == 0 ]] && echo '${_LG}✔' || echo '${_LR}✘') \t "

# Promopt username only when user switched (happens after sudo -s -u <user>)
if [[ $(logname 2>/dev/null) != $(id -un) ]] || [[ $USER != $(id -un) ]]; then
    PS1="${PS1}${_LR}$(id -un)${_NC}@"
fi

# Detect whether this box has my own ssh key (~/.ssh/$USER.key), distinguish
# hostname color and setup ssh-agent related environment accordingly
#
if [[ -f ~/.ssh/$USER.key ]]; then
    # I am on my own machine, try load ssh-agent related environments
    PS1="${PS1}${_LB}"                              # blue hostname
    _MY_AGENT_RC=~/.ssh-agent.rc
    [[ ! -f $_MY_AGENT_RC ]] || source $_MY_AGENT_RC
    if ! ps -p ${SSH_AGENT_PID:-0} >& /dev/null; then
        print -P "${_LR}Starting new ssh-agent process${_NC}" >&2
        ssh-agent -s -a ~/.ssh-agent.sock | sed '/^echo/d' > $_MY_AGENT_RC
        source $_MY_AGENT_RC
        ssh-add -L | grep -qw $USER.key || ssh-add ~/.ssh/$USER.key
    fi
else
    # Otherwise assume I am on other's box, highlight hostname in magenta
    PS1="${PS1}${_LM}"                              # magenta hostname
fi

PS1="${PS1}$(_H=$(hostname -f); echo ${_H%.yahoo.*})"
PS1="${PS1}${_LG}"                                  # then green {yroot}
PS1="${PS1}"${YROOT_NAME+"{$YROOT_NAME}"}
PS1="${PS1} ${_LY}\w${_NC}"                         # yellow cwd
PS1="${PS1}\[\$(__git_status_color)\]"              # git status indicator
PS1="${PS1}\$(__git_active_branch)"                 # git branch name
PS1="${PS1}${_LC}\$(__git_track_info)"              # git branch track info
PS1="${PS1}${_LC} ⤾\n"                              # cyan wrap char, newline
PS1="${PS1}\$([[ -z \$(jobs) ]] || echo '$_RV')"    # reverse bg job indicator
PS1="${PS1}\\\$${_NC} "                             # $ or #
unset _LR _LG _LY _LB _LM _LC _RV _NC

# Shortcuts (Aliases, function, auto completion etc.)
#
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
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
    [[ -n "$file_glob" ]] || file_glob="*"
    [[ -n "$paths" ]] || paths="."

    find $paths \( -path '*/.svn' -o -path '*/.git' -o -path '*/.idea' \) \
        -prune -o -type f -name "$file_glob" -print0 -follow \
        | eval "xargs -0 -P128 grep -EH $grep_opts '$string_pat'"
}

# vim:set et sts=4 sw=4 ft=sh:
