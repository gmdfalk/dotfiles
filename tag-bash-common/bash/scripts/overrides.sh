#!/usr/bin/env bash
if ! have clear; then
    alias clear='printf "\033c"'
fi

if have grc; then
    alias .cl="grc -es --colour=auto"
    alias configure=".cl ./configure"
    alias diff=".cl diff"
    alias make=".cl make"
    alias gcc=".cl gcc"
    alias g++=".cl g++"
    alias as=".cl as"
    alias ld=".cl ld"
    alias netstat=".cl netstat"
    alias ping=".cl ping"
    alias traceroute=".cl traceroute"
fi