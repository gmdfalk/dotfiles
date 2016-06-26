#!/usr/bin/env bash

backup() {
    [[ "$#" -lt 2 ]] && echo "Usage: backup <src>... <dest>" && return 1

    # Save all arguments but the last one into the src array.
    local length=$(( $# - 1 ))
    local src=(${@:1:${length}})
    # Save the last argument as destination.
    local dest="${@:$#}"

    [[ -d "${dest}" ]] || mkdir -p "${dest}" &>/dev/null
    [[ $? != 0 || ! -w "$dest" ]] && echo "Cannot write to destination $dest." && return 1

    # archive, keep attributes, keep extended attributes, verbose, delete obsolete destination files
    rsync -aAXv --delete --exclude={\
"${dest}/*","/dev/*","/proc/*","/sys/*","/tmp/*","/run/*","/mnt/*","/media/*","/lost+found",\
"/.snapshots","/home/.snapshots","/var/lib/docker/btrfs/subvolumes",\
"/home/*/.thumbnails","/home/*/.cache/spotify","/home/*/.cache/mozilla","/home/*/.cache/chromium",\
"/home/*/.local/share/Trash/*","/home/*/.gvfs"\
} "${src[@]}" "${dest}"
}

# {{{ Suspend/Halt/Reboot
slp() { systemctl suspend; }
hlt() { systemctl poweroff; }
rbt() { systemctl reboot; }
slpin() { count "$1" && slp; }
hltin() { count "$1" && hlt; }
rbtin() { count "$1" && rbt; }
# }}}

# {{{ rcm/dotfiles
alias cddot="cd ${HOME}/.dotfiles"
rcupd() {
    cd ~/.dotfiles
    git pull
    rcup -v "$@"
    cd -
}
# }}}

