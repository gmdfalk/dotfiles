#!/usr/bin/env bash

if have hub; then
    alias git="hub"
fi

g() {
  if [[ $# -gt 0 ]]; then
    git "$@"
  else
    git status
  fi
}
