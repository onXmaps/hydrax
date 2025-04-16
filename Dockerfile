FROM golang:1.22.5 AS builder

COPY . .

RUN CGO_ENABLED=0 go build -o /opt/hydra

FROM gcr.io/distroless/static-debian12:nonroot

COPY --from=builder --chown=nonroot /opt/hydra /usr/bin/hydra

# Declare the standard ports used by hydra (4444 for public service endpoint, 4445 for admin service endpoint)
EXPOSE 4444 4445

ENTRYPOINT ["hydra"]
CMD ["serve", "all"]
