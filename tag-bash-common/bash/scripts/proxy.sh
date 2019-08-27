#!/usr/bin/env bash

PROXY_VARS=("http_proxy" "ftp_proxy" "https_proxy" "all_proxy" "HTTP_PROXY" "HTTPS_PROXY" "FTP_PROXY" "ALL_PROXY")
NO_PROXY_VARS=("no_proxy" "NO_PROXY")
DEFAULT_PROXY="http://proxy:3128"
DEFAULT_NO_PROXY="localhost,127.0.0.1,id.dvag.com,infra.dvag.com,mon.dvag.com,dvag.net"

export_proxy(){
    set_variables "$1" "${PROXY_VARS[@]}"
    set_variables "$2" "${NO_PROXY_VARS[@]}"
}

proxy() {  # print proxy settings
    print_variables "${PROXY_VARS[@]}"
    print_variables "${NO_PROXY_VARS[@]}"
}

proxy_on() {
    local proxy="$1"
    local noproxy="$2"
    [[ -z "${proxy}" ]] && proxy="${DEFAULT_PROXY}"
    [[ -z "${noproxy}" ]] && noproxy="${DEFAULT_NO_PROXY}"
    export_proxy "${proxy}" "${noproxy}"
}

proxy_off() {
    export_proxy
}

set_variables() {
    local value="$1"
    shift
    for env_var in "$@"; do
        export "${env_var}"="$value"
    done
}

print_variables() {
    for var in "$@"; do
        [[ -n "${ZSH_VERSION}" ]] && echo "${var}: ${(P)var}" || echo "${var}: ${!var}"
    done
}

