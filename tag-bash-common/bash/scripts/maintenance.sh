#!/usr/bin/env bash

sysbackup() {
    # archive, keep attributes, keep extended attributes, verbose, delete obsolete destination files
    rsync -aAXv --delete --exclude={"/dev/*","/proc/*","/sys/*","/tmp/*","/run/*","/mnt/*","/media/*","/var/lib/docker/btrfs/subvolumes","/lost+found","/home/*/.thumbnails","/home/*/.cache/spotify","/home/*/.cache/mozilla","/home/*/.cache/chromium","/home/*/.local/share/Trash/*","/home/*/.gvfs","/.snapshots"} / /media/backup
}



slpin() { count "$1" && systemctl suspend; }

# Update rcm configuration
rcupd() {
    cd ~/.dotfiles
    git pull
    rcup -v "$@"
    popd
}

alias cpr="rsync --partial --progress --append --rsh=ssh -r -h "
alias mvr="rsync --partial --progress --append --rsh=ssh -r -h --remove-sent-files"
alias dfh="btrfs filesystem df -h /"

alias lnew="ls --color=auto -lhrt"
alias lold="ls --color=auto -lht"
alias lsmall="ls --color=auto -lSh"
alias labig="ls --color=auto -lArSh" 
alias lanew="ls --color=auto -lAhrt"
alias laold="ls --color=auto -lAht"
alias lasmall="ls --color=auto -lASh"

alias pingg="ping www.google.com"
f() { find . | grep -is "$@"; }
ff() { find . -type f | xargs grep -is "$@"; }
fp() { find $(sed 's/:/ /g' <<< "${PATH}") | grep -is "$@"; }
psf() { ps aux | grep "$@"; }
wgp() { wgetpaste -X "$@"; }
grab() { sudo chown -R ${USER}:${USER} ${1-.}; }
alias vn="${VISUAL} ${HOME}/.note"
alias vnn="$VISUAL $HOME/.notemed"
alias raw='grep -Ev "^\s*(;|#|$)"'
debug() { bash -x $(which "$1") "${@:1}"; }

alias cm="chmod"
alias cmx="chmod +x"
