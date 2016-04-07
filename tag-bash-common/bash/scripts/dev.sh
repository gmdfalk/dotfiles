#!/usr/bin/env bash

# {{{ Languages
alias rb="ruby"
alias py="python"
alias py2="python2"
alias py3="python3"
alias ipy="ipython"
alias ipy2="ipython2"
alias ipy3="ipython3"
# }}}

# {{{ Navigation
alias cdb="cd ${HOME}/build"
alias cdc="cd ${HOME}/code"
# }}}

# {{{ Utilities
# Get or set keyboard layout.
# The german layout is horrible for programming, which is why i often switch to GB or US.
# Note for us -altgr-intl: AltGr+p=ö, AltGr+q=ä.
kbd() {
    case "$@" in
        us|US)
            setxkbmap us -variant altgr-intl;;
        gb|GB|uk|UK|en|EN)
            setxkbmap gb;;
        de|DE)
            setxkbmap de -variant nodeadkeys;;
        '')
            setxkbmap -query;;
        *)
            setxkbmap "$@";;
    esac
}
# }}}
