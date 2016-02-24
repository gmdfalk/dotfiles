#!/usr/bin/env bash

export_proxy(){
    local proxy_vars=(http_proxy ftp_proxy https_proxy all_proxy HTTP_PROXY HTTPS_PROXY FTP_PROXY ALL_PROXY)
    local no_proxy_vars=(no_proxy NO_PROXY)
    for env_var in "${proxy_vars[@]}"; do
        export ${env_var}="$1"
    done
    for env_var in "${no_proxy_vars[@]}"; do
        export ${env_var}="$2"
    done
}

proxy_on() {
    local proxy="$1"
    [[ -z "${proxy}" ]] && proxy="http://idproxy.id.dvag.com:3128"
    local no_proxy="$2"
    [[ -z "${no_proxy}" ]] && no_proxy="localhost,127.0.0.1,dvag.com,dvag.net"
    export_proxy "${proxy}" "${no_proxy}"
}

proxy_off() {
  export_proxy ""  
}

