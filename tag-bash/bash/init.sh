#!/usr/bin/env bash

BASH_DIR="$HOME/.bash/custom/plugins"

for extension in ${EXTENSIONS[$@]}; do
    . ${BASH_DIR}/${extension}.sh
done
