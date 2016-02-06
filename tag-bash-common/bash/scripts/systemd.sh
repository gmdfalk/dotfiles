#!/usr/bin/env bash

alias sc="systemctl"

system_state() {
    journalctl -p 0..3 -xn
    echo "\nFailed systemctl units:"
    systemctl --failed
}

user_commands=(
  list-units is-active status show help list-unit-files
  is-enabled list-jobs show-environment cat)

sudo_commands=(
  start stop reload restart try-restart isolate kill
  reset-failed enable disable reenable preset mask unmask
  link load cancel set-environment unset-environment
  edit)

for c in "${user_commands}"; do
    alias sc-$c="systemctl $c"
done

for c in "${sudo_commands}"; do
    alias sc-$c="$SUDO systemctl $c"
done
