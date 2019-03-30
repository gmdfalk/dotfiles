#!/usr/bin/env zsh

alias mv="nocorrect mv"
alias rm="nocorrect rm"
alias cp="nocorrect cp"
alias calc="noglob calc"

# If you are using 'sudo ' to allow usage of sudo with aliases, it can choke when trying to evaluate
# shell reserved words like 'nocorrect'.
# See http://superuser.com/questions/749314/how-do-you-set-alias-sudo-nocorrect-sudo-correctly.
alias sudo="noglob do_sudo "
do_sudo() {
    integer glob=1
    local -a run
    run=( command sudo )
    if [[ "$#" -gt 1 && "$1" = -u ]]; then
        run+=("$1" "$2")
        shift 2
    fi
    [[ $# == 0 ]] && 1=/bin/zsh
    while (($#)); do
        case "$1" in
            command|exec|-) shift; break ;;
            nocorrect) shift ;;
            noglob) glob=0; shift ;;
            *) break ;;
        esac
    done
    if ((glob)); then
        PATH="/sbin:/usr/sbin:/usr/local/sbin:$PATH" $run $~==*
    else
        PATH="/sbin:/usr/sbin:/usr/local/sbin:$PATH" $run $==*
    fi
}