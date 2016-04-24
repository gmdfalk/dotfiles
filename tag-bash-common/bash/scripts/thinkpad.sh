#!/usr/bin/env bash

# This command can be used to run commands specifically as the logged in X11 user with proper X support.
# Acpid/Pm-utils and similar use something like this when running commands for the user as root.
execute_with_display() {
    for X in "/tmp/.X11-unix/X"*; do
        local x11_user
        local display="${X##/tmp/.X11-unix/X}"
        if [[ -x "$(which w)" ]]; then
            x11_user="$(w -h | awk -vD="$display" '$2 ~ ":"D"(.[0-9])?$" || $3 ~ ":"D"(.[0-9])?$" {print $1}' | head -n1)"

            if [[ -z "$x11_user" ]];  then
                x11_user="$(w -h | awk -vD="$display" '$7 ~ "xinit" && $0 ~ ":"D"(.[0-9])?" {print $1}' | head -n1)"
            fi
        else
            x11_user="$(who --all | awk -vD="$display" '$3 ~ ":"D"(.[0-9])?$" {print $1}' | head -1)"
        fi

        # Execute the command as the X11 user.
        [[ "$x11_user" ]] && DISPLAY=":$display" su -c "${@}" "$x11_user"
    done
}

# Uses autorandr to automatically detect docking state and apply xrandr accordingly.
autodock() {
    local resolution_cmd="autorandr -c --default mobile --force"
    local keyboard_layout="$(xinput -query | grep layout | awk '{print $2}')"
    # Wait until the (un)docking process has completed
    sleep "${1:-1}"

    if [[ "${UID}" == 0 ]]; then
        execute_with_display "${resolution_cmd}"
    else
        eval "${resolution_cmd}"
    fi
    trackpoint
    kbd "${keyboard_layout}"
    xmodmap "${HOME}/.Xmodmap"
}

# Control trackpoint speed.
trackpoint() {
    local speed=${1:-0.3}
    # Find the ids of all trackpoint pointer devices.
    local trackpoints=($(xinput | grep "TrackPoint.*pointer" | grep -oP "(?<=id=)\d+"))
    for trackpoint in "${trackpoints[@]}"; do
        xinput --set-prop "${trackpoint}" "Evdev Wheel Emulation" 1
        xinput --set-prop "${trackpoint}" "Evdev Wheel Emulation Button" 2
        xinput --set-prop "${trackpoint}" "Evdev Wheel Emulation Timeout" 200
        xinput --set-prop "${trackpoint}" "Evdev Wheel Emulation Axes" 6 7 4 5
        xinput --set-prop "${trackpoint}" "Device Accel Constant Deceleration" "${speed}"
    done
    echo "${speed}"
}

dock() {
    xrandr --output eDP1 --mode 1920x1080
    xrandr --output DP2-1 --mode 1920x1200 --right-of eDP1
    xrandr --output DP2-2 --mode 1920x1200 --right-of DP2-1
}

undock() {
    xrandr --output eDP1 --mode 1920x1080
}

fan() { # control fan
    local fanfile=/proc/acpi/ibm/fan
    case "$1" in
        1|on|enable|auto) echo level auto | ${_SUDO} tee "${fanfile}";;
        0|off|disable)    echo disable | ${_SUDO} tee "${fanfile}";;
        '')               cat "${fanfile}";;
        dog)              echo watchdog 120 | ${_SUDO} tee "${fanfile}";;
        *)                echo level $@ | ${_SUDO} tee "${fanfile}";;
    esac
}
