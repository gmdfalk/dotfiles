#!/bin/sh
# ~/.xinitrc
#

. ~/.xprofile

# Common apps
#compton &
#firefox &
#dropboxd &
nm-applet --sm-disable &

exec /usr/bin/awesome >> ~/.logs/awe_out 2>> ~/.logs/awe_err
#exec startkde
