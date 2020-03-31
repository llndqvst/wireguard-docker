FROM alpine:3.11.5 as base

FROM base as builder

RUN apk update && \
    apk add --no-cache \
    build-base

RUN mkdir -p /build

COPY wireguard-tools /wireguard-tools

ENV DESTDIR /build
ENV WITH_SYSTEMDUNITS no
ENV WITH_BASHCOMPLETION no

WORKDIR /wireguard-tools/src

RUN make install

FROM base

COPY --from=builder /build /

COPY docker-entrypoint.sh /usr/bin/docker-entrypoint.sh

ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["wg"]