#!/usr/bin/env bash

# Linux {{{
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


# Change the keyboard layout. For a full list of available layouts and variants look here: http://pastebin.com/v2vCPHjs.
# The german layout is horrible for programming, which is why i often switch to GB (sometimes US international).
# Umlauts for GB:            ä=AltGr+[a, ö=AltGr+[o, ü=AltGr+[u, ß=AltGr+s.
# Umlauts for Mac GB:        ä=Alt+ua,   ö=Alt+uo,   ü=Alt+uu,   ß=Alt+s.
# On OS X, you can use xkbswitch (https://github.com/myshov/xkbswitch-macosx) as an alternative to setxkbmap.
# Umlauts for US altgr-intl: ä=AltGr+q,  ö=AltGr+p,  ü=AltGr+y,  ß=AltGr+s.
keyboard() {
    case "$(tty)" in
        # We're using the virtual console.
        /dev/tty[0-9]*)
            case "$1" in
                den)
                     localectl set-keymap --no-convert de-latin1-nodeadkeys
                     loadkeys de-latin1-nodeadkeys;;
                gb|uk|en)
                     localectl set-keymap --no-convert uk
                     loadkeys uk;;
                gbi|uki|eni) setxkbmap gb -variant intl;;
                '') localectl status;;
                ls) localectl list-keymaps;;
                *)
                     localectl set-keymap --no-convert "$@"
                     loadkeys "$@";;
            esac
        ;;
        # We're probably using a pseudo terminal.
        *)
            case "$1" in
                den) setxkbmap de -variant nodeadkeys;;
                usi) setxkbmap us -variant altgr-intl;;
                gb|uk|en) setxkbmap gb;;
                gbi|uki|eni) setxkbmap gb -variant intl;;
                '') setxkbmap -query;;
                ls) localectl list-x11-keymap-layouts;;
                lsvar) [[ -z "$2" ]] && localectl list-x11-keymap-variants || localectl list-x11-keymap-variants "$2";;
                *) setxkbmap "$@";;
            esac
            # Reapply any customizations to the layout.
            have xmodmap && xmodmap "${HOME}/.Xmodmap" &>/dev/null
            #have xbindkeys && xbindkeys
        ;;
    esac
}

rootkit_check() {
  /usr/bin/rkhunter --versioncheck --nocolors
  /usr/bin/rkhunter --update --nocolors
  /usr/bin/rkhunter --cronjob --nocolors --report-warnings-only
  /usr/bin/freshclam
  /usr/bin/clamscan --recursive --infected /home
}
# }}}