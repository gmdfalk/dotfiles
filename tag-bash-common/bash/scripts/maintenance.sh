#!/usr/bin/env bash

sysbackup() {
    # archive, keep attributes, keep extended attributes, verbose, delete obsolete destination files
    rsync -aAXv --delete --exclude={"/dev/*","/proc/*","/sys/*","/tmp/*","/run/*","/mnt/*","/media/*","/var/lib/docker/btrfs/subvolumes","/lost+found","/home/*/.thumbnails","/home/*/.cache/spotify","/home/*/.cache/mozilla","/home/*/.cache/chromium","/home/*/.local/share/Trash/*","/home/*/.gvfs","/.snapshots"} / /media/backup
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
    cd "${OLDPWD}"
}
# }}}


