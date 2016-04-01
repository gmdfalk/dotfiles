#!/usr/bin/env bash

tpspeed() {
    local speed=${1:-0.4}
    xinput set-prop "TPPS/2 IBM TrackPoint" "Evdev Wheel Emulation" 1
    xinput set-prop "TPPS/2 IBM TrackPoint" "Evdev Wheel Emulation Button" 2
    xinput set-prop "TPPS/2 IBM TrackPoint" "Evdev Wheel Emulation Timeout" 200
    xinput set-prop "TPPS/2 IBM TrackPoint" "Evdev Wheel Emulation Axes" 6 7 4 5
    xinput set-prop "TPPS/2 IBM TrackPoint" "Device Accel Constant Deceleration" $speed
    echo $speed
}

apply_dock_xrandr() {
    xrandr --output eDP1 --mode 1920x1080
    xrandr --output DP2-1 --mode 1920x1200 --right-of eDP1
    xrandr --output DP2-2 --mode 1920x1200 --right-of DP2-1
}
fan() { # control fan
    local fanfile=/proc/acpi/ibm/fan
    case "$1" in
        1|on|enable|auto) echo level auto | ${_SUDO} tee $fanfile;;
        0|off|disable)    echo disable | ${_SUDO} tee $fanfile;;
        '')               cat $fanfile;;
        dog)              echo watchdog 120 | ${_SUDO} tee $fanfile;;
        *)                echo level $@ | ${_SUDO} tee $fanfile;;
    esac
}