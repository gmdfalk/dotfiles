#!/usr/bin/env bash

# {{{ Vars
ACPI="/sys/devices/platform/thinkpad_acpi"
BAT="/sys/devices/platform/smapi/BAT0"
BL="/sys/class/backlight/intel_backlight/brightness"
BT="${ACPI}/bluetooth_enable"
# }}}

# {{{ Network
alias wolh="wol 40:61:86:87:F3:FE"
alias sshh="ssh ${_HTPC}"
alias pingh="ping 192.168.0.2"
# }}}

# {{{ Display
if have backlight; then
    alias bl=backlight
fi

doff() {
    local cmd
    [[ -n "$1" ]] && cmd="ssh ${_HTPC} DISPLAY=:0 "
    cmd+="xset dpms force off"
    eval ${cmd}
}
don() {
    local cmd
    [[ -n "$1" ]] && cmd="ssh ${_HTPC} DISPLAY=:0 "
    cmd+="xset dpms force on"
    eval ${cmd}
}
# }}}




