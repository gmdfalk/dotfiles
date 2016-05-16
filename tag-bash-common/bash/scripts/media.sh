#!/usr/bin/env bash

# Media control {
# Blockify shortcuts
bb() {
    usage() { echo "Usage: bb ( b[lock] | u[nblock] | p[revious] | n[ext] | t[oggle] | t[oggle]b[lock] | ... )"; }
    local signal
    local cmd
    [[ "$1" == "--host" ]] && cmd="ssh $2 " && shift 2
    case "$1" in
        ""|g|get|status)
            cmd+="blockify-dbus get $2";;
        ex|exit)
            signal='TERM';;       # Exit
        b|block)
            signal='USR1';;       # Block
        u|unblock)
            signal='USR2';;       # Unblock
        p|previous)
            signal='RTMIN';;      # Previous song
        n|next)
            signal='RTMIN+1';;    # Next song
        t|toggle)
            signal='RTMIN+2';;    # Toggle play song
        tb|toggleblock)
            signal='RTMIN+3';;    # Toggle block song
        ip|iprevious)
            signal='RTMIN+10';;   # Previous interlude song
        in|inext)
            signal='RTMIN+11';;   # Next interlude song
        it|itoggle)
            signal='RTMIN+12';;   # Toggle play interlude song
        itr|itoggleresume)
            signal='RTMIN+13';;   # Toggle interlude resume
        *) usage && return 0;;
    esac
    [[ "${signal}" ]] && cmd+="pkill --signal ${signal} -f '/usr/bin/blockify'"
    echo "${cmd}"
    eval "${cmd}"
}
bbh() { bb --host "${_HTPC}" "$@"; }

# Playerctl shortcuts
pc() {
    usage() { echo "Usage: pc [ p[revious] | n[ext] | t[oggle] | v[olume] | s[top] ]"; }
    local cmd
    [[ "$1" == "--host" ]] && cmd="ssh $2 " && shift 2
    case "$1" in
        ''|g|get|state|status) arg="status";;
        p|previous) arg="previous";;
        n|next) arg="next";;
        t|toggle) arg="play-pause";;
        v|volume) arg="volume $2";;
        s|stop) arg="stop";;
        *) usage && return 0;;
    esac
    cmd+="playerctl-wrapper ${arg}"
    echo "${cmd}"
    eval "${cmd}"
}
pch() { pc --host "${_HTPC}" "$@" ; }

# Show or set system volume.
vol() {
    [[ "$#" -gt 1 ]] && echo "Usage: vol [<volume>]" && return 0
    if have pamixer; then
        [[ "$#" == 1 ]] && pamixer --set-volume "$1"
        pamixer --get-volume
    elif have amixer; then
        [[ "$#" == 1 ]] && amixer -q set Master "${1}%"
        amixer get Master "$1"
    else
        echo "Could not find amixer or pamixer."
    fi
}

# Vlc sometimes completely blocks the suspend process so we have to force it into submission.
slpin() { count "$1" && (kill -9 $(pgrep vlc); sudo umount -l ~/htpc ; systemctl suspend); }
# }

# Record {
twitch() { # stream my shit on twitch
    [[ -z "$INRES" ]] && INRES=1920x1200
    [[ -z "$OUTRES" ]] && OUTRES=1920x1200
    [[ -z "$FPS" ]] && FPS=30
    [[ -z "$SERVER" ]] && SERVER=live-fra
    [[ -z "$TWITCHKEY" ]] && TWITCHKEY=$(cat ~/.twitchkey)
    [[ -z "$TOPXY" ]] && TOPXY="0,0"             # screen region. 0,0 = whole screen
    [[ -z "$GETX" ]] && GETX=${TOPXY%%,*}
    [[ -z "$AUDIOSRC" ]] && AUDIOSRC="pulse"     # audio source. alsa e.g. hw:0,0, pulse = pulse
    [[ -z "$PRESET" ]] && PRESET=veryfast        # your x264 ffmpeg preset file
    [[ -z "$THREADS" ]] && THREADS=4             # 4 or 6 for good CPUs
    # -vf scale=$GETX:-1
    # for audio add: -f alsa -ac 2 -i "$AUDIOSRC" -b:v 650k -b:a 64k -acodec libmp3lame -ar 44100 -ab 64k
    ffmpeg -f x11grab -s "$INRES" -r "$FPS" -i :0.0+"$TOPXY" -ss 2 -vcodec libx264 -preset "$PRESET" -pix_fmt yuv420p -threads "$THREADS" -f flv rtmp://"$SERVER".justin.tv/app/"$TWITCHKEY"
}

twitchw() { # stream (only) a selected screen region
    emulate -L zsh
    source <(awk 'TOPXY[FNR]=$4 {next} ; INRES[FNR]=$2 {next}; END { print "TOPXY="TOPXY[8]","TOPXY[9]; print "INRES="INRES[12]"x"INRES[13] }' < <(xwininfo))
    twitch
}

alias soundrecord="ffmpeg -f alsa -ac 2 -i hw:0 -vn -acodec libmp3lame -ab 196k capture.mp3"
alias soundtest="aplay /usr/share/sounds/alsa/Front_Center.wav"
# }

# Media {
alias cdm="cd ~/htpc"
alias cdinc="cdn ~/htpc/inc"
alias cdmov="cdn ~/htpc/mov"
alias cdser="cdn ~/htpc/ser"
alias mntm="cd && ${_SUDO} mount ~/htpc"
alias umntm="cd && ${_SUDO} umount ~/htpc"
# }

# Dropbox {
alias cdbox="cd ~/box"
alias cdaus="cd ~/box/ausbildung"
# }


# Notes {
note() { # Write a note to a target file
    local target=$1
    [[ -f "${target}" ]] || touch "${target}"
    if [[ "$#" == 0 ]];then
        echo "Usage: note <filename> <message>"
    elif [[ "$#" == 1 ]];then
        cat "${target}" | tail -n 20
    else
        shift
        echo "$@" >> "${target}"
    fi
}
# }


