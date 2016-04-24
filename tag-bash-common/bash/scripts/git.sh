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

# {{{ Commit
alias gcam="gc --amend" # Amend staged files to the latest commit (prompts to edit message).
alias gcamr="gc --amend --reuse-message=HEAD"
alias gresign="gst && gcamr --gpg-sign && gst pop"
gccredit() { git commit --amend --author "$1 <$2>" --reuse-message=HEAD; } # Credit an author on the latest commit.
# Create a commit with a different date by specifying the offset in hours, e.g. gcdate -2 backdates the commit by 2 hours.
gcdate() {
    [[ "$#" -lt 1 ]] && echo "Usage: gcdate <hours>" && return
    gc --date="$(date -R -d "$1 hours")" "${@:2}"
}
# }}}

# {{{ Branch
alias gba='git branch -a'
alias gbt='git branch --track'
alias gbd='git branch -D'
# Remove branches that have already been merged with master
# a.k.a. ‘delete merged’
alias gbdm="git branch --merged | grep -v '\\*' | xargs -n 1 git branch -d"
# Switch to a branch, creating it if necessary
gcb() { git checkout -b "$1" 2> /dev/null || git checkout "$1"; }
alias gct='git checkout --track'
# }}}

# {{{ Fetch
# Fetch and remove any remote-tracking references that no longer exist on the remote.
alias gfp="git fetch --all --prune --verbose"
# Fetch including remote tags. Tags are not pruned.
alias gftag="git fetch --all --prune --tags --verbose"
# }}}

# {{{ Info
# Show verbose output about tags, branches or remotes
alias gtags="git tag -l"
alias gbranches="git branch -a"
alias gremotes="git remote -v"
alias gcount="git shortlog --summary --numbered"
# View the current working tree status using the short format
alias gss="git status -s"
# Show the diff between the latest commit and the current state.
alias gd="git diff-index --quiet HEAD -- || clear; git --no-pager diff --patch-with-stat"
# `git di $number` shows the diff between the state `$number` revisions ago and the current state
#gdi() {
    #d() { git diff --patch-with-stat "HEAD~$1"; };
    #git diff-index --quiet HEAD -- || clear
    #d
#}
# Find branches containing commit
gfb() { git branch -a --contains "$1"; }
# Find tags containing commit
gft() { git describe --always --contains "$1" ; }
# Find commits by source code
gfc() { git log --pretty=format:'%C(yellow)%h  %Cblue%ad  %Creset%s%Cgreen  [%cn] %Cred%d' --decorate --date=short -S$1; }
# Find commits by commit message
gfm() { git log --pretty=format:'%C(yellow)%h  %Cblue%ad  %Creset%s%Cgreen  [%cn] %Cred%d' --decorate --date=short --grep=$1; }
# }}}

# {{{ Log
# View abbreviated SHA, description, author and time of commits
gl() { git log --graph --pretty=format:'%C(bold)%h%Creset%C(yellow)%d%Creset %s %C(yellow)%an %C(cyan)%cr%Creset' --abbrev-commit --date=relative; }
# View abbreviated SHA, description, and history graph (of the latest 20 commits)
alias gll="git log --pretty=oneline --graph --abbrev-commit"
alias gls="git log --pretty=oneline --graph --abbrev-commit -n 20"
# Show commits since last pull
alias glnew="git log HEAD@{1}..HEAD@{0}"
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

