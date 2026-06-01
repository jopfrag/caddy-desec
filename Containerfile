FROM docker.io/caddy:2-builder AS builder

RUN --mount=type=cache,target=/go/pkg/mod \
    --mount=type=cache,target=/root/.cache/go-build \
    xcaddy build \
    --with github.com/caddy-dns/desec \
    --with github.com/mholt/caddy-dynamicdns

FROM docker.io/alpine:3

COPY --from=builder /usr/bin/caddy /usr/bin/caddy

ENTRYPOINT [ "/usr/bin/caddy" ]

CMD [ "run" ]
