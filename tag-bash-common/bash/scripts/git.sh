#!/usr/bin/env bash

# {{{ Preparation
# Hub is a fully compatible wrapper for git that adds GitHub support, e.g. creating issues and pull requests.
have hub && alias git="hub"
# }}}

# {{{ Basics
# When no arguments are given, do git status.
#g() { [[ "$#" -gt 0 ]] && git "$@" || git status --short; }
alias g="git"
# }}}


# {{{ Push & Pull
alias gpr='git pull --rebase'
alias gpp='git pull && git push'
alias gup='git fetch && git rebase'
alias gpo='git push origin'
alias gpu='git push --set-upstream'
alias gpom='git push origin master'
# Pull in remote changes for the current repository and all its submodules
alias gpa="git pull; git submodule foreach git pull origin master"
# Push origin to master
alias gpm="git push origin master"
# Interactive rebase with the given number of latest commits
greb() { git rebase -i HEAD~"$1"; }
# Initialize and update all submodules recursively
alias gsu="git submodule update --init --recursive"
alias gmu='git fetch origin -v; git fetch upstream -v; git merge upstream/master'
# }}}

# {{{ Various
alias gaa="git add -A"
alias gclr="git clone --recursive"
alias gdv='git diff -w "$@" | vim -R -'
alias gremadd="git remote add"

# Merge GitHub pull request on top of the `master` branch
gmpr() {
    if [ $(printf "%s" "$1" | grep '^[0-9]\\+$' > /dev/null; printf $?) -eq 0 ]; then
        git fetch origin refs/pull/"$1"/head:pr/"$1" &&
        git rebase master pr/"$1" &&
        git checkout master &&
        git merge pr/"$1" &&
        git branch -D pr/"$1" &&
        git commit --amend -m "$(git log -1 --pretty=%B)\n\nCloses #$1.";
    fi
}
# }}}

