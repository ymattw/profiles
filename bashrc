# Matthew Wang's Bash Profile for general Linux/Unix
#
# Suggestion: ln -sf .bashrc .bash_profile
#

# Fancy PS1, prompt the '$' in red when we have background jobs, '\[' and '\]'
# is to mark ansi colors to allow shell to calculate prompt string length
# correctly
#
PS1='\[\e[1;4m\]'                                               # ansi hi & ul
PS1="$PS1"'\[\e[31m\]'                                          # red
PS1="$PS1"'\h'                                                  # short hostname
PS1="$PS1"'\[\e[0;1;4m\]'                                       # reset color
PS1="$PS1"':\w '                                                # cwd
PS1="$PS1"'\[$([[ -z $(jobs) ]] || echo -e "\e[7;31m")\]'       # reverse jobs
PS1="$PS1"'\$\[\e[0m\] '                                        # $, end color
export PS1
export EDITOR=vim
export TERM=linux
export GREP_OPTIONS="--color=auto"

# To start a global ssh-agent: ssh-agent | sed /^echo/d > ~/.ssh-agent.rc
[[ ! -r ~/.ssh-agent.rc ]] || source ~/.ssh-agent.rc

# Shortcuts (Aliases, function, auto completion etc.)
#
case $(uname -s) in
    Linux)
        alias ls='/bin/ls -F --color=auto'
        alias l='/bin/ls -lF --color=auto'
        alias lsps='ps -ef f | grep -vw grep | grep -i'
        ;;
    Darwin)
        alias ls='/bin/ls -F'
        alias l='/bin/ls -lF'
        alias lsps='ps -ax -o user,pid,ppid,%cpu,%mem,start,comm | grep -vw grep | grep -i'
        ;;
    *)
        alias ls='/bin/ls -F'
        alias l='/bin/ls -lF'
        alias lsps='ps -auf | grep -vw grep | grep -i'
        ;;
esac

# Find a File by pattern
function f() {
    local pat=${1?'Usage: f pattern [path...]'}
    shift
    find ${@:-.} -regex '.*\.\(idea\|svn\|git\).*' \
        -prune -o -print | grep -i "$pat"
}

# Load file list generated by function f() above in vim, you can type 'gf' to
# jump to the file
#
function vif() {
    local tmpf=$(mktemp)
    f "$@" > $tmpf && vi -c "/$1" $tmpf && rm -f $tmpf
}

# Grep a string in currently dir by file pattern quickly
function g() {
    file_pat=$1
    string_pat=${2:?"Usage: g 'file-pattern' 'string-pattern' [grep options]"}
    shift 2
    find . -type f -name "$file_pat" -print0 \
        | xargs -0 -n1 -P128 grep -H "$string_pat" "$@"
}

# Auto complete unset from exported variables
complete -A export unset

# vim:set et sts=4 sw=4 ft=sh:
