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
# Basics {
add_completion_alias "py" "python"
add_completion_alias "py2" "python2"
add_completion_alias "py3" "python3"
alias ipy="ipython"
alias ipy2="ipython2"
alias ipy3="ipython3"
# }

# PyPI {
# See http://peterdowns.com/posts/first-time-with-pypi.html for a quick intro on how to use PyPI.
alias ppregister="python setup.py register -r pypi"
alias ppupload="python setup.py sdist upload -r pypi"
alias pptregister="python setup.py register -r pypitest"
alias pptupload="python setup.py sdist upload -r pypitest"
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
# }}}

# Java {{{
[[ -n "${JAVA_HOME}" ]] || export JAVA_HOME="/usr/lib/jvm/default"
# }}}
