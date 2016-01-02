#!/bin/sh
# ~/.xinitrc
#

xrdb -merge ~/.Xresources

envfile="$HOME/.gnupg/gpg-agent.env"
if [[ -e "$envfile" ]] && kill -0 $(grep GPG_AGENT_INFO "$envfile" | cut -d: -f 2) 2>/dev/null; then
    eval "$(cat "$envfile")"
else
    eval "$(gpg-agent --daemon --enable-ssh-support --write-env-file "$envfile")"
fi
export GPG_AGENT_INFO  # the env file does not contain the export statement
export SSH_AUTH_SOCK   # enable gpg-agent for ssh

## Ensure that the D-Bus Communication System is running properly to fix
## File management, authentication, and other essential system processes
if which dbus-launch >/dev/null && test -z "$DBUS_SESSION_BUS_ADDRESS"; then
    eval "$(dbus-launch --sh-syntax --exit-with-session)"
fi

## Ensure that GTK themes are applied uniformly in the Desktop Environment
export GTK2_RC_FILES="$HOME/.gtkrc-2.0"

## Where the default Home folders have not already been created, generate them
if [ -x /usr/bin/xdg-user-dirs-update ]; then
   /usr/bin/xdg-user-dirs-update
fi

# X11 environment
start-pulseaudio-x11
setxkbmap de # -variant nodeadkeys
xmodmap ~/.xmodmaprc
xbindkeys
xset s off dpms 0 0 300 &
xinput set-prop "TPPS/2 IBM TrackPoint" "Evdev Wheel Emulation" 1 &
xinput set-prop "TPPS/2 IBM TrackPoint" "Evdev Wheel Emulation Button" 2 &
xinput set-prop "TPPS/2 IBM TrackPoint" "Evdev Wheel Emulation Timeout" 200 &
xinput set-prop "TPPS/2 IBM TrackPoint" "Evdev Wheel Emulation Axes" 6 7 4 5 &
xinput set-prop "TPPS/2 IBM TrackPoint" "Device Accel Constant Deceleration" 0.8 &

# Common apps
nm-applet --sm-disable &
pidgin &
thunderbird &
firefox &
(sleep 10 && dropbox) &

if ping -c 1 htpc &>/dev/null;then
   mount ~/media
fi

exec /usr/bin/awesome >> ~/.logs/awe_out 2>> ~/.logs/awe_err
#exec startkde
