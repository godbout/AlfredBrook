#!/bin/bash

get_vpn_names() {
  scutil --nc list | grep "com.txthinking.brook" | awk -F'"' '{print$2}'
}

get_vpn_status() {
  local vpn=$1
  scutil --nc status "$vpn" | head -n 1 | grep -i "connected"
}

vpn_list() {
  IFS=$'\n'
  declare -a vpns=( `get_vpn_names` )

  # output JSON
  jsonstr="{\"items\":["
  for vpn in "${vpns[@]}";do
    conn=$(get_vpn_status $vpn )
    jsonstr+="{\"title\":\"$vpn\",\"subtitle\":\"$conn\",\"arg\":\"$vpn\",";
    if [[ "$conn" == "Connected" ]]; then
      jsonstr+="\"icon\":{\"path\":\"./images/on.png\"}"
    else
      jsonstr+="\"icon\":{\"path\":\"./images/off.png\"}"
    fi
    jsonstr+="},"
  done
  jsonstr="${jsonstr%,}"
  jsonstr+="]}"
  echo -e $jsonstr
}

# execute vpn_list
vpn_list
