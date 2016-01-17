#!/usr/bin/env bash

# {{{ Set environment variables
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

[[ -n "$DISPLAY" ]] && BROWSER="firefox" || BROWSER="lynx"
[[ "$OSTYPE" == "darwin"* ]] && BROWSER="open"
# }}}

# {{{ Exporting
export BROWSER EDITOR LESS PAGER PATH TMPDIR VISUAL
[[ -z "$LANG" ]] && export LANG="en_US.UTF-8"
# }}}