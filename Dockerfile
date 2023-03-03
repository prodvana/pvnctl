FROM debian:bullseye-slim AS builder

# trunk-ignore(hadolint/DL3008): these tools are just helper tools
RUN apt-get update -y && apt-get install -y --no-install-recommends jq curl ca-certificates

ARG VERSION=latest

COPY install-pvnctl.sh /
RUN /install-pvnctl.sh

FROM scratch

COPY --from=builder /usr/local/bin/pvnctl /usr/local/bin/pvnctl
