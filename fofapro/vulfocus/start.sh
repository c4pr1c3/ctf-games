#!/usr/bin/env bash

command -V jq 1>/dev/null 2>&1

if [[ $? -ne 0 ]];then
    echo "jq is required to run this script"
    exit 1
fi

local_ips=()

ifs=($(ls -l /sys/class/net/ | grep -v virtual | sed -n -E 's/.*net\/(.*)/\1/p'))
for dev in "${ifs[@]}";do
    if [[ -n "$dev" ]];then
        ipv4_addr=$(ip -details -json a show "$dev" | jq -r '.[] | .addr_info[] | select(.family == "inet") | .local')
	local_ips+=("$ipv4_addr")
    fi
done

echo "========== physical ip list =========="
echo "${local_ips[@]}"
echo "Host-only IP is prefered in Virtualbox Setup"
echo -n "plz enter your LOCAL_IP (default ${local_ips[0]}) "
read LOCAL_IP

isset_local_ip=0
for ipv4_addr in "${local_ips[@]}";do
    if [[ "$ipv4_addr" == "$LOCAL_IP" ]];then
	isset_local_ip=1
        break
    fi
done

if [[ $isset_local_ip -eq 0 ]];then
    LOCAL_IP="${local_ips[0]}"
fi

echo "$LOCAL_IP will be set as LOCAL_IP"

cat <<EOF > vulfocus.env
VUL_IP=${LOCAL_IP}
EMAIL_HOST=${EMAIL_HOST}
EMAIL_HOST_USER=${EMAIL_HOST_USER}
EMAIL_HOST_PASSWORD=${EMAIL_HOST_PASSWORD}
EOF

docker compose up -d

if [[ $? -ne 0 ]];then
    echo "docker compose up failed, try docker-compose up -d"
    docker-compose up -d
fi
