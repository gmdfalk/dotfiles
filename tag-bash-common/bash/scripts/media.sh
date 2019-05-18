#!/usr/bin/env bash

# Media control {
# Playerctl shortcuts
player() {
    usage() { echo "Usage: player [i[nfo] | t[oggle] | s[top] | p[revious] | n[ext] | v[olume] [<perc>] | m[ute]]"; }
    local cmd
    local player
    [[ -n $(pgrep spotify) ]] && player="spotify"
    case "$1" in
        ''|g|get|state|status) cmd="playerctl status";;
        p|previous) cmd="playerctl previous";;
        n|next) cmd="playerctl next";;
        t|toggle) cmd="playerctl play-pause";;
        v|volume) [[ -z "$2" ]] && cmd="pamixer --get-volume" || cmd="pamixer --set-volume $2";;
        m|mute) cmd="pamixer --toggle-mute";;
        s|stop) cmd="playerctl stop";;
        *) usage && return 0;;
    esac
    [[ "${cmd}" == playerctl* && -n "${player}" ]] && cmd+=" --player=${player}"
    eval "${cmd}"
}

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
# }

# Record {
twitch() { # stream my shit on twitch
    [[ -z "$INRES" ]] && INRES=1920x1080
    [[ -z "$OUTRES" ]] && OUTRES=1920x1080
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
    ffmpeg -f x11grab -s "$INRES" -r "$FPS" -i :0.0+"$TOPXY" -ss 2 -vcodec libx264 -preset "$PRESET" -pix_fmt yuv420p -threads "$THREADS" -f flv rtmp://"$SERVER".twitch.tv/app/"$TWITCHKEY"
}

twitchw() { # stream (only) a selected screen region
    emulate -L zsh
    source <(awk 'TOPXY[FNR]=$4 {next} ; INRES[FNR]=$2 {next}; END { print "TOPXY="TOPXY[8]","TOPXY[9]; print "INRES="INRES[12]"x"INRES[13] }' < <(xwininfo))
    twitch
}

alias soundrecord="ffmpeg -f alsa -ac 2 -i hw:0 -vn -acodec libmp3lame -ab 196k capture.mp3"
alias soundtest="aplay /usr/share/sounds/alsa/Front_Center.wav"
# }





