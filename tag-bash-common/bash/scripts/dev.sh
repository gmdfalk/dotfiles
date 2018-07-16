#!/usr/bin/env bash

# Navigation {{{
alias cdb="cd ${HOME}/build"
alias cdc="cd ${HOME}/code"
# }}}

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

    # Virtualenv {
    # Virtualenvwrapper workflow: mkvirtualenv foo, workon foo, deactivate, rmvirtualenv foo
    # Other useful commands: lsvirtualenv (list all environments), cdvirtualenv (cd into one), cdsitepackages, lssitepackages
    if [[ -x /usr/bin/virtualenvwrapper_lazy.sh ]]; then
        export PROJECT_HOME="${HOME}/code/python"
        export WORKON_HOME="${HOME}/build/python/venv"
        export VIRTUALENVWRAPPER_SCRIPT=/usr/bin/virtualenvwrapper.sh
        # Isolate new environments from system site packages. Opposite would be --system-site-packages.
        #export VIRTUALENVWRAPPER_VIRTUALENV_ARGS='--no-site-packages'
        source /usr/bin/virtualenvwrapper_lazy.sh
    fi
    # }
fi
# }}}

# Java {{{
[[ -n "${JAVA_HOME}" ]] || export JAVA_HOME="/usr/lib/jvm/default"
# }}}

if have kubectl; then
  add_completion_alias "kb" "kubectl"
  alias kbew="k8 -n entwicklung-wserver"
  alias kbei="k8 -n entwicklung-innolab"
fi

if have idea; then
    # On OSX with Jetbrains Toolbox, the idea app is sandboxed and tries to open files with the sandbox location as root and fails.
    # Instead substitute pwd so we can use 'idea some/dir/file.txt'.
    ideao() {
        local target="$@"
        [[ ${target} =~ ^/.* ]] || target="${PWD}/${target}"
        echo "Opening ${target} with $(which idea)".
        idea "${target}" > /dev/null 2>&1
    }
fi
