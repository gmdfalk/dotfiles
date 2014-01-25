#!/bin/sh
# ~/.xinitrc
#

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
#start-pulseaudio-x11
setxkbmap de -variant nodeadkeys
xmodmap ~/.xmodmaprc
xset s off dpms 0 0 300 &

# Host specific startup
if [[ $HOSTNAME = htpc ]];then
    wspotify &
    pkill -f blockify &
    (sleep 10; blockify) &
    sudo vbetool dpms off &
    #eval $(gpg-agent --daemon) &
else
    xchat &
fi

# Common apps
compton &
firefox &
dropboxd &

exec /usr/bin/awesome >> ~/.logs/awe_out 2>> ~/.logs/awe_err
