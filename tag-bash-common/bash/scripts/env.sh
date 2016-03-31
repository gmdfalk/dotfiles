#!/usr/bin/env bash


# {{{ Basic environment
# Add scripts directory to $PATH, if it's missing.
BIN_DIR="${HOME}/bin"
case ":$PATH:" in
  *":$BIN_DIR:"*) :;; # already there
  *) PATH="$BIN_DIR:$PATH";; # or PATH="$PATH:$new_entry"
esac
PAGER=less
LESS="-F -g -i -M -R -S -w -X -z-4"

if [[ -z "${VISUAL}" ]]; then
    have vim && VISUAL="vim" || VISUAL="vi"
fi
EDITOR="${VISUAL}"

if [[ ! -d "$TMPDIR" ]]; then
  TMPDIR="/tmp/${LOGNAME}"
  mkdir -p -m 700 "${TMPDIR}"
fi

# GUI
[[ -n "$DISPLAY" ]] && BROWSER="firefox" || BROWSER="lynx"
# }}}

# {{{ Export environment
export BROWSER \
       EDITOR \
       LESS \
       PAGER \
       PATH \
       TMPDIR \
       VISUAL

[[ -z "$LANG" ]] && export LANG="en_US.UTF-8"
# }}}

# {{{ Cygwin
if [[ $OSTYPE == "cygwin" ]];then
    # By default, cygwin creates "fake" symlinks which are just regular files with the path of the linked file as content.
    # This only works inside Cygwin, breaking e.g. .gitconfig functionality if it should be sourced outside of Cygwin.
    # Thus, we tell Cygwin to use native NTFS symlinks (but beware as they can behave different to unix symlinks).
    export CYGWIN="winsymlinks:native"
fi
# }}}

# {{{ Msys
if [[ "$OSTYPE" != "msys" ]];then
    # Disable scroll locking the terminal via ^s and ^q.
    stty -ixon
    # Colors for ls
    [[ -r "$HOME/.dircolors" ]] && eval "$(dircolors $HOME/.dircolors)"
fi
# }}}

# {{{ OSX
if [[ "$OSTYPE" == "darwin"* ]];then
    _OPEN="open"
fi
# }}}

# {{{ Various Settings
# Supress warnings about accessibility bus
NO_AT_BRIDGE=1
# }}}


# {{{ Custom variables
_HTPC="192.168.0.2"
_OPEN="xdg-open"
_VIDEO="vlc"
[[ "$UID" == 0 ]] || _SUDO="sudo"
# }}}
