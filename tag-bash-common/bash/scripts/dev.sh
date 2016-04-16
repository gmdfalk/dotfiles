#!/usr/bin/env bash

# {{{ Navigation
alias cdb="cd ${HOME}/build"
alias cdc="cd ${HOME}/code"
# }}}

# {{{ Ruby
alias rb="ruby"
# }}}

# {{{ Python
# { Basics
alias py="python"
alias py2="python2"
alias py3="python3"
alias ipy="ipython"
alias ipy2="ipython2"
alias ipy3="ipython3"
# }

# { PyPI
# See http://peterdowns.com/posts/first-time-with-pypi.html for a quick intro on how to use PyPI.
alias ppregister="python setup.py register -r pypi"
alias ppupload="python setup.py sdist upload -r pypi"
alias pptregister="python setup.py register -r pypitest"
alias pptupload="python setup.py sdist upload -r pypitest"
# }

# { Virtualenv
# Virtualenvwrapper workflow: mkvirtualenv foo, workon foo, deactivate, rmvirtualenv foo
# Other useful commands: lsvirtualenv (list all environments), cdvirtualenv (cd into one), cdsitepackages, lssitepackages
export PROJECT_HOME="${HOME}/code/python"
export WORKON_HOME="${HOME}/build/python/venv"
export VIRTUALENVWRAPPER_SCRIPT=/usr/bin/virtualenvwrapper.sh
# Isolate new environments from system site packages. Opposite would be --system-site-packages.
#export VIRTUALENVWRAPPER_VIRTUALENV_ARGS='--no-site-packages'
source /usr/bin/virtualenvwrapper_lazy.sh
# }
# }}}

# {{{ Utilities

# }}}

# {{{ Kafka+Storm
ZOO="/usr/share/zookeeper"
alias cdzoo="cd ${ZOO}"
alias zoostart="${_SUDO} ${ZOO}/bin/zkServer.sh start"
alias zooconnect="${_SUDO} ${ZOO}/bin/zkCli.sh -server 127.0.0.1:2181"
STORM="/usr/share/storm"
alias cdstorm="cd ${STORM}"
