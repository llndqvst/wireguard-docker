#!/bin/bash

### Further modified from https://github.com/cmulk/wireguard-docker
## The below is modified from https://github.com/activeeos/wireguard-docker

# Find a Wireguard interface
# interfaces=`find /etc/wireguard -type f`
# if [[ -z $interfaces ]]; then
#     echo "$(date): Interface not found in /etc/wireguard" >&2
#     exit 1
# fi
cat /config/interfaces >> /etc/network/interfaces


ifup wg0
# for interface in $interfaces; do
#     echo "$(date): Starting Wireguard $interface"
#     wg-quick up $interface
# done

# Handle shutdown behavior
finish () {
    echo "$(date): Shutting down Wireguard"
    # for interface in $interfaces; do
    #     wg-quick down $interface
    # done
    ifdown wg0

    exit 0
}

trap finish SIGTERM SIGINT SIGQUIT

exec "$@" &

sleep infinity & wait
