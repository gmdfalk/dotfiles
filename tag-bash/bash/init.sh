#!/usr/bin/env bash


# {{{ Utilities
have() {
    type "$@" &>/dev/null
}
# }}}

# {{{ Plugins
PLUGINS_DIR="$HOME/.bash/plugins"
for PLUGIN in ${BASH_PLUGINS[@]}; do
    [[ -f "${PLUGINS_DIR}/${PLUGIN}.sh" ]] && source "${PLUGINS_DIR}/${PLUGIN}.sh"
done
# }}}
