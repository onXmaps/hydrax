FROM golang:1.23 AS builder

COPY . .

RUN GO111MODULE=on GOOS=linux GOARCH=amd64 go build -o /opt/hydra

FROM alpine:3.20

RUN apk add --no-cache --upgrade ca-certificates

# Add a user/group for nonroot with a stable UID + GID. Values are from nonroot from distroless
# for interoperability with other containers.
RUN addgroup --system --gid 65532 nonroot && \
    adduser --system --uid 65532 \
      --gecos "nonroot User" \
      --home /home/nonroot \
      --ingroup nonroot \
      --shell /sbin/nologin \
      nonroot

COPY --from=builder /opt/hydra /usr/bin/hydra

USER nonroot

ENTRYPOINT ["hydra"]
CMD ["serve", "all"]
