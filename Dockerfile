FROM golang:1.20.2 AS builder

COPY go.mod go.sum src/
COPY dnscrypt-proxy src/dnscrypt-proxy
COPY vendor src/vendor

WORKDIR /go/src/dnscrypt-proxy
RUN CGO_ENABLED=0 go build -mod vendor -ldflags="-s -w"


FROM alpine:3.17.2
RUN apk add --no-cache curl
COPY --from=builder /go/src/dnscrypt-proxy/dnscrypt-proxy .
COPY entrypoint.sh cloaking-rules.txt dnscrypt-proxy.toml forwarding-rules.txt ./

CMD ["./entrypoint.sh"] 