#!/usr/bin/env bash

sysbackup() {
    # archive, keep attributes, keep extended attributes, verbose, delete obsolete destination files
    rsync -aAXv --delete --exclude={"/dev/*","/proc/*","/sys/*","/tmp/*","/run/*","/mnt/*","/media/*","/var/lib/docker/btrfs/subvolumes","/lost+found","/home/*/.thumbnails","/home/*/.cache/spotify","/home/*/.cache/mozilla","/home/*/.cache/chromium","/home/*/.local/share/Trash/*","/home/*/.gvfs","/.snapshots"} / /media/backup
}

system_state() {
    systemctl --failed
    journalctl -p 0..3 -xn
}

slpin() { count "$1" && systemctl suspend; }