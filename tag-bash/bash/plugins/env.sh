#!/usr/bin/env bash

PATH=$HOME/bin:${PATH}
PAGER=less
LESS="-F -g -i -M -R -S -w -X -z-4"

if [[ -z "$VISUAL" ]]; then
    have vim && VISUAL=vim || VISUAL=vi
fi
EDITOR=$VISUAL

if [[ ! -d "$TMPDIR" ]]; then
  TMPDIR="/tmp/$LOGNAME"
  mkdir -p -m 700 "$TMPDIR"
fi

if [[ "$OSTYPE" == "darwin"* ]]; then
    BROWSER="open"
else
    BROWSER="lynx"
fi

if [[ -n "$DISPLAY" ]]; then
    BROWSER="firefox"
fi

export BROWSER EDITOR LESS PAGER PATH TMPDIR VISUAL

if [[ -z "$LANG" ]]; then
  export LANG="en_US.UTF-8"
fi