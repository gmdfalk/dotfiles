#!/usr/bin/env bash

# zmv {{{
autoload -U zmv
alias mmv="noglob zmv -W"
mmvlc() { [[ $1 = -r ]] && zmv '(**/)(*)' '$1${(L)2}' || zmv '(*)' '${(L)1}'; } # To lower case.
mmvsp() { [[ $1 = -r ]] && zmv '(**/)(* *)' '$f:gs/ /_' || zmv '(* *)' '$f:gs/ /_'; } # Remove special characters.
# }}}

