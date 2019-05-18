#!/usr/bin/env bash

# {{{ Basic environment
export XDG_CACHE_HOME=$HOME/.cache
export XDG_CONFIG_HOME=$HOME/.config
export XDG_DATA_HOME=$HOME/.local/share
export GNUPGHOME="$XDG_CONFIG_HOME"/gnupg
export GPG_TTY="$(tty)"
HISTSIZE=500000
SAVEHIST=$HISTSIZE


# Add scripts directory to $PATH, if it's missing.
BIN_DIR="${HOME}/bin"
case ":$PATH:" in
    *":$BIN_DIR:"*) :;; # already there
    *) PATH="$BIN_DIR:$PATH";; # or PATH="$PATH:$new_entry"
esac
PAGER=less
LESS="-F -g -i -M -R -S -w -X -z-4"

if [[ -z "${VISUAL}" ]]; then
    have vim && VISUAL="vim -p" || VISUAL="vi"
fi
EDITOR="${VISUAL}"

if [[ ! -d "$TMPDIR" ]]; then
    TMPDIR="/tmp/${LOGNAME}"
    mkdir -p -m 700 "${TMPDIR}"
fi

# GUI
[[ -n "$DISPLAY" ]] && BROWSER="chromium" || BROWSER="lynx"

[[ -z "$LANG" ]] && export LANG="en_US.UTF-8"
export BROWSER \
       EDITOR \
       LESS \
       PAGER \
       PATH \
       TMPDIR \
       VISUAL
# }}}

# {{{ OSX
if [[ "$OSTYPE" == "darwin"* ]];then
    _OPEN="open"
fi
# }}}

# {{{ Development
export _JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=setting'
# }}}

# {{{ Various Settings
# Supress warnings about accessibility bus
NO_AT_BRIDGE=1
# }}}

# {{{ Custom variables
_OPEN="xdg-open"
_VIDEO="vlc"
# }}}

# {{{ Sudo
# Bash only checks the first word of a command for an alias, any words after that are not checked.
# If the last character of the alias value is a space or tab character, then the next command word following the alias
# is also checked for alias expansion (http://askubuntu.com/questions/22037/aliases-not-available-when-using-sudo).
#alias sudo='sudo '
# Prefix commands that require root privileges with $_SUDO so that they work when logged in as root, too.
[[ "$UID" == 0 ]] || _SUDO="sudo"
# }}}

# Completion {{{
_COMPLETION_ALIASES=()
# Adds a straightforward alias, something like `alias g=git` while also marking that alias for the common shell framework
# to add to the shell completion mechanism. 
add_completion_alias() {
    local alias="$1"
    local command="$2"

    alias "${alias}"="${command}"
    _COMPLETION_ALIASES+=("${alias}:${command}")
}
