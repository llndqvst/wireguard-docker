FROM alpine:3.12 as base

RUN apk update && \
    apk add --no-cache \
    bash iproute2 openresolv ip6tables iptables wireguard-tools-wg

COPY docker-entrypoint.sh /usr/bin/docker-entrypoint.sh

ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["wg"]
