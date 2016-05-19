#!/usr/bin/env bash

export SYSTEMD_EDITOR="${EDITOR}"

scstate() {
    journalctl -p 0..3 -xn
    echo "\nFailed systemctl units:"
    systemctl --failed
}

alias sc="systemctl"

user_commands=(
  list-units is-active status show help list-unit-files
  is-enabled list-jobs show-environment cat)

sudo_commands=(
  start stop reload restart try-restart isolate kill
  reset-failed enable disable reenable preset mask unmask
  link load cancel set-environment unset-environment
  edit)

for c in "${user_commands}"; do
    alias sc-${c}="systemctl ${c}"
done

for c in "${sudo_commands}"; do
    alias sc-${c}="${_SUDO} systemctl ${c}"
done
