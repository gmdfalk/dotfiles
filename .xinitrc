#!/bin/sh
# ~/.xinitrc
#

xrdb -merge ~/.Xresources

#eval $(gpg-agent --daemon --enable-ssh-support)
#export SSH_AUTH_SOCK

if ! pgrep -u $USER ssh-agent > /dev/null; then
    ssh-agent > ~/.ssh-agent-thing
fi
if [[ "$SSH_AGENT_PID" == "" ]]; then
    eval $(<~/.ssh-agent-thing)
fi
ssh-add -l >/dev/null || alias ssh='ssh-add -l >/dev/null || ssh-add && unalias ssh; ssh'


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
(sleep 10 &&
xinput set-prop "TPPS/2 IBM TrackPoint" "Evdev Wheel Emulation" 1
xinput set-prop "TPPS/2 IBM TrackPoint" "Evdev Wheel Emulation Button" 2
xinput set-prop "TPPS/2 IBM TrackPoint" "Evdev Wheel Emulation Timeout" 200
xinput set-prop "TPPS/2 IBM TrackPoint" "Evdev Wheel Emulation Axes" 6 7 4 5
xinput set-prop "TPPS/2 IBM TrackPoint" "Device Accel Constant Deceleration" 0.8) &

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
