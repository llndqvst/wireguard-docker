#!/bin/bash

### Further modified from https://github.com/cmulk/wireguard-docker
## The below is modified from https://github.com/activeeos/wireguard-docker

# Find a Wireguard interface
originalIP=`wget -qO- ifconfig.co`
interfaces=`find /etc/wireguard -type f`
if [[ -z $interfaces ]]; then
    echo "$(date): Interface not found in /etc/wireguard" >&2
    exit 1
fi


for interface in $interfaces; do
    echo "$(date): Starting Wireguard $interface"
    wg-quick up $interface
done

# Handle shutdown behavior
finish () {
    echo "$(date): Shutting down Wireguard"
    for interface in $interfaces; do
        wg-quick down $interface
    done

    exit 0
}

trap finish SIGTERM SIGINT SIGQUIT

exec "$@" &

while :
do
    wgIP=`wget -qO- ifconfig.co`
    echo $wgIP
    [[ $wgIP != $originalIP ]] || exit 1
    sleep 350
done
