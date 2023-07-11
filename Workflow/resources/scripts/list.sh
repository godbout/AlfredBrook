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

  jsonstr="{\"items\":["

  if [[ -z "$vpns" ]]; then
      jsonstr+="{\"title\":\"No Brook VPN found ☹️\",\"subtitle\":\"You need to install Brook and set up your VPN first. Press return now!\",\"arg\":\"dickLOL\",}";
  else
    for vpn in "${vpns[@]}";do
      conn=$(get_vpn_status $vpn)
      jsonstr+="{\"arg\":\"$vpn\",";
      if [[ "$conn" == "Connected" ]]; then
        jsonstr+="\"title\":\"disconnect\",\"subtitle\":\"$vpn\",\"icon\":{\"path\":\"./resources/icons/disconnect.png\"}"
      else
        jsonstr+="\"title\":\"connect\",\"subtitle\":\"$vpn\",\"icon\":{\"path\":\"./resources/icons/connect.png\"}"
      fi
      jsonstr+="},"
    done
  fi

  jsonstr="${jsonstr%,}"
  jsonstr+="]}"
  echo -e $jsonstr
}

# execute vpn_list
vpn_list
