FROM alpine:3.11.5 as base

FROM base as builder

RUN apk update && \
    apk add --no-cache \
    build-base linux-headers \
    iproute2 iptables ip6tables

RUN mkdir -p /build

COPY wireguard-tools /wireguard-tools

ENV DESTDIR /build
ENV WITH_SYSTEMDUNITS no
ENV WITH_BASHCOMPLETION no
ENV WITH_WGQUICK yes

WORKDIR /wireguard-tools/src

RUN make install

FROM base

COPY --from=builder /build /

RUN apk update && \
    apk add --no-cache \
    bash iproute2 openresolv ip6tables iptables


COPY docker-entrypoint.sh /usr/bin/docker-entrypoint.sh

ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["wg"]