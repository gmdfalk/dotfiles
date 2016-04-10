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
# Change the keyboard layout. For a full list of available layouts and variants look here: http://pastebin.com/v2vCPHjs.
# The german layout is horrible for programming, which is why i often switch to GB (sometimes US international).
# Umlauts for GB:            ä=AltGr+[a, ö=AltGr+[o, ü=AltGr+[u, ß=AltGr+s.
# Umlauts for Mac GB:        ä=Alt+ua,   ö=Alt+uo,   ü=Alt+uu,   ß=Alt+s.
# On OS X, you can use xkbswitch (https://github.com/myshov/xkbswitch-macosx) as an alternative to setxkbmap.
# Umlauts for US altgr-intl: ä=AltGr+q,  ö=AltGr+p,  ü=AltGr+y,  ß=AltGr+s.
kbd() {
    case "$@" in
        den|DEN)
            setxkbmap de -variant nodeadkeys;;
        usi|USI)
            setxkbmap us -variant altgr-intl;;
        gb|GB|uk|UK|en|EN)
            setxkbmap gb;;
        '')
            setxkbmap -query;;
        *)
            setxkbmap "$@";;
    esac
    # Reapply any customizations to the layout.
    have xmodmap && xmodmap "${HOME}/.Xmodmap" &>/dev/null
    #have xbindkeys && xbindkeys
}
# }}}
