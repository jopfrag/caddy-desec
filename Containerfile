FROM docker.io/caddy:2-builder AS builder

RUN --mount=type=cache,target=/go/pkg/mod \
    --mount=type=cache,target=/root/.cache/go-build \
    xcaddy build \
    --with github.com/caddy-dns/desec@latest \
    --with github.com/mholt/caddy-dynamicdns@latest

FROM docker.io/alpine:3

ENV XDG_CONFIG_HOME=/config
ENV XDG_DATA_HOME=/data

RUN <<EOF
    apk add --no-cache ca-certificates
    mkdir -p /config/caddy /data/caddy /etc/caddy
EOF

COPY --from=builder /usr/bin/caddy /usr/bin/caddy

EXPOSE 443
VOLUME [ "/config" ]
VOLUME [ "/data" ]
VOLUME [ "/etc/caddy"]

ENTRYPOINT [ "/usr/bin/caddy" ]
CMD [ "run", "--config", "/etc/caddy/Caddyfile", "--adapter", "caddyfile" ]
