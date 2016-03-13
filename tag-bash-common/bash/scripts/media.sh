#!/usr/bin/env bash

# Blockify shortcuts
bb() {
    local signal
    local cmd
    case "$1" in
        "")  blockify-dbus get 2>/dev/null && return 0;;
        ex)  signal='TERM';;       # Exit
        b)   signal='USR1';;        # Block
        u)   signal='USR2';;        # Unblock
        p)   signal='RTMIN';;       # Previous song
        n)   signal='RTMIN+1';;     # Next song
        t)   signal='RTMIN+2';;     # Toggle play song
        tb)  signal='RTMIN+3';;    # Toggle block song
        pi)  signal='RTMIN+10';;   # Previous interlude song
        ni)  signal='RTMIN+11';;   # Next interlude song
        ti)  signal='RTMIN+12';;   # Toggle play interlude song
        tir) signal='RTMIN+13';;  # Toggle interlude resume
        *) echo "Bad option" && return 0;;
    esac
    cmd="pkill --signal $signal -f 'python.*blockify'"
    if [[ $2 == "htpc" ]];then
        cmd="$SSH2 \"${cmd}\""
    fi
    eval "${cmd}"
}

bbr() {
    bb "$1" "htpc"
}

pc() {
    case "$1" in
        "") arg="status";;
        p) arg="previous";;
        n) arg="next";;
        t) arg="play-pause";;
        v) arg="volume $2";;
        s) arg="stop";;
        *) echo "Bad option" && return 0;;
    esac
    if have playerctl-wrapper; then
        playerctl-wrapper "$arg"
    else
        playerctl "$arg"
    fi
}

note() { # Write a note to a target file
    local target=$1
    [[ -f "$target" ]] || touch "$target"
    if [[ $# = 0 ]];then
        echo "usage: note <filename> <message>"
    elif [[ $# = 1 ]];then
        cat "$target" | tail -n 20
    else
        shift
        echo "$@" >> "$target"
    fi
}


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

slpin() { count "$1" && pkill vlc; sudo umount -l ~/htpc ; systemctl suspend; }

alias mntm="$SUDO mount ~/htpc"
alias umntm="cd && $SUDO umount ~/htpc"
alias cdm="cd ~/htpc"
