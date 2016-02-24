#!/usr/bin/env bash

export_proxy(){
    local proxy_env_vars=(http_proxy ftp_proxy https_proxy all_proxy HTTP_PROXY HTTPS_PROXY FTP_PROXY ALL_PROXY)
    for proxy_env_var in "${proxy_vars}"; do
        export $proxy_env_var="$1"
    done
    for proxy_env_var in "no_proxy NO_PROXY"; do
        export $proxy_env_var="$2"
    done
}

proxy_on() {
    local proxy="${1:http://idproxy.id.dvag.com:3128}"
    local no_proxy="${2:localhost,127.0.0.1,dvag.com,dvag.net}"
    echo $proxy $no_proxy
    return
    export_proxy "${proxy}" "${no_proxy}"
}

proxy_off() {
  export_proxy ""  
}

