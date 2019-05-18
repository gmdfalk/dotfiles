#!/usr/bin/env bash

# {{{ Git
# Hub is a fully compatible wrapper for git that adds GitHub support, e.g. creating issues and pull requests.
have hub && alias git="hub"

# When no arguments are given, do git status.
#g() { [[ "$#" -gt 0 ]] && git "$@" || git status --short; }
add_completion_alias "g" "git"
alias gs="git status -s"
# }}}

# Ruby {{{
if have ruby; then
    add_completion_alias "rb" "ruby"
    export PATH="$(ruby -e 'print Gem.user_dir')/bin:$PATH"
    export GEM_HOME=$(ruby -e 'print Gem.user_dir')
    export GEM_PATH="${GEM_HOME}"
fi
# }}}

# {{{ Python
if have python; then
    # Basics {
    add_completion_alias "py" "python"
    if have python2; then
        add_completion_alias "py2" "python2"
        add_completion_alias "py3" "python3"
    fi
    # }
fi
# }}}

# Java {{{
[[ -n "${JAVA_HOME}" ]] || export JAVA_HOME="/usr/lib/jvm/default"
# }}}


# Various {{{
alias pingg="ping www.google.com"
alias raw='grep -Ev "^\s*(;|#|$)"'
psf() { ps aux | grep "$@" | grep -v grep; }
wgp() { wgetpaste -X "$@"; }
debug() { bash -x $(which "$1") "${@:1}"; }
#sprunge() { curl -F 'sprunge=<-' http://sprunge.us }
# }}}

# Networking {{{
myip() { curl ipinfo.io; }
speedtest() { curl -s https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py | python - }
# }}}
