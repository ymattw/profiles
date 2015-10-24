# Matthew Wang's bash profile for general Linux/Unix
#
# Suggestion: ln -sf .bashrc .bash_profile
#

# Source global definitions but unset PROMPT_COMMAND as tmux manages it
[[ ! -f /etc/profile ]] || . /etc/profile
[[ ! -f /etc/bashrc ]] || . /etc/bashrc
unset PROMPT_COMMAND

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
bind 'set match-hidden-files off' >& /dev/null  # Don't tab-expand hidden files
! shopt -q login_shell || stty stop undef       # Make 'C-s' to do i-search

# Useful environments. Locale (LC_*) matters for ls and sort on Linux, see also
# www.gnu.org/software/coreutils/faq/#Sort-does-not-sort-in-normal-order_0021
#
export HISTFILE=~/.bash_history     # In case switched from zsh temporally
export HISTSIZE=10000
export EDITOR=vim
if [[ $(uname -s) == Linux ]]; then
    export LC_COLLATE=C
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

# Customized theme (prompt)
#
_DR="\[\e[31m\]"        # red
_DG="\[\e[32m\]"        # green
_DY="\[\e[33m\]"        # yellow
_DB="\[\e[34m\]"        # blue
_DM="\[\e[35m\]"        # magenta
_DC="\[\e[36m\]"        # cyan
_RV="\[\e[7m\]"         # reverse
_NC="\[\e[0m\]"         # no color

function __git_status_color() {
    if [[ $(git rev-parse --is-inside-work-tree 2>/dev/null) == true ]]; then
        local info=$(git status -s)
        if [[ -z $info ]]; then
            echo -ne "\033[32m"       # clean status
        elif [[ -z $(echo "$info" | grep -v '^??') ]]; then
            echo -ne "\033[35m"       # has untracked objects only
        else
            echo -ne "\033[31m"       # unclean status
        fi
    fi
}

function __git_active_branch() {
    if [[ $(git rev-parse --is-inside-work-tree 2>/dev/null) == true ]]; then
        local branch=$(git symbolic-ref HEAD 2>/dev/null)
        branch=${branch#refs/heads/}
        echo " (${branch})"
    fi
}

function __git_track_info() {
    if [[ $(git rev-parse --is-inside-work-tree 2>/dev/null) == true ]]; then
        local branch info age track
        branch=$(git symbolic-ref HEAD 2>/dev/null)
        branch=${branch#refs/heads/}
        info=$(git status -s 2>/dev/null)
        age=$(git log --pretty=format:'%cr' -1 refs/heads/$branch 2>/dev/null)
        track=$(git status -sb 2>/dev/null | sed -n 's/^##.*\[\(.*\)\].*/, \1/p')
        echo " [${age}${track}]"
    fi
}

# Fancy PS1, prompt exit status of last command, currenet time, hostname, time,
# cwd, git status and branch, also prompt the '%' in reverse color when we have
# background jobs. '\[' and '\]' is to mark ansi colors to allow shell to
# calculate prompt string length correctly
#
PS1="\$([[ \$? == 0 ]] && echo '${_DG}✔' || echo '${_DR}✘') \t "

# Detect whether this box has my own ssh key (~/.ssh/$USER.key), distinguish
# hostname color and setup ssh-agent related environment accordingly
#
if [[ -f ~/.ssh/$USER.key ]]; then
    # I am on my own machine, try load ssh-agent related environments
    PS1="${PS1}${_DB}"                              # blue hostname
    _MY_AGENT_RC=~/.ssh-agent.rc
    [[ ! -f $_MY_AGENT_RC ]] || source $_MY_AGENT_RC
    if ! ps -p ${SSH_AGENT_PID:-0} 2>/dev/null | grep -q ssh-agent; then
        echo -e "${_DR}Starting new ssh-agent process${_NC}" >&2
        rm -f ~/.ssh-agent.sock
        ssh-agent -s -a ~/.ssh-agent.sock | sed '/^echo/d' > $_MY_AGENT_RC
        source $_MY_AGENT_RC
    fi
    ssh-add -L | grep -qw $USER.key || ssh-add ~/.ssh/$USER.key
else
    # Otherwise assume I am on other's box, highlight hostname in magenta
    PS1="${PS1}${_DM}"                              # magenta hostname
fi

# Highlight hostname in reverse green if inside a container
if [[ -n $container_uuid ]] || [[ -f /.dockerenv ]]; then
    PS1="${PS1}${_RV}${_DG}"
fi
PS1="${PS1}$(hostname -f)"
PS1="${PS1}${_NC}:${_DY}\w${_NC}"                   # yellow cwd
PS1="${PS1}\[\$(__git_status_color)\]"              # git status indicator
PS1="${PS1}\$(__git_active_branch)"                 # git branch name
PS1="${PS1}${_DC}\$(__git_track_info)"              # git branch track info
PS1="${PS1}${_DC} ⤾\n"                              # cyan wrap char, newline
PS1="${PS1}\$([[ -z \$(jobs) ]] || echo '$_RV')"    # reverse bg job indicator
PS1="${PS1}\\\$${_NC} "                             # $ or #
unset _DR _DG _DY _DB _DM _DC _RV _NC

# Shortcuts (Aliases, function, auto completion etc.)
#
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
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
    [[ -n "$paths" ]] || paths="."

    find $paths \( -path '*/.svn' -o -path '*/.git' -o -path '*/.idea' \) \
        -prune -o -type f -print0 -follow \
        | eval "xargs -0 -P128 grep -EH $grep_opts '$string_pat'"
}

# vim:set et sts=4 sw=4 ft=sh:
