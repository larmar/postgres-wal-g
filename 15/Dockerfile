FROM golang:1.23 AS build

ARG WALG_RELEASE=v3.0.5
ENV USE_LIBSODIUM=1

RUN apt-get update -qq && apt-get install -qqy --no-install-recommends --no-install-suggests git curl cmake build-essential libsodium-dev && \
    cd /go/src/ && \
    git clone -b $WALG_RELEASE --recurse-submodules https://github.com/wal-g/wal-g.git && \
    cd wal-g && \
    go mod tidy && \
    make pg_clean && \
    make deps && \
    GOBIN=/go/bin make pg_install

FROM postgres:15
LABEL maintainer="Linserv AB <info@linserv.se"

RUN apt-get update  && apt-get install -y \
    libsodium23 \
    curl \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

#    apt-get install -qqy curl ca-certificates libsodium23 vim

COPY --from=build /go/bin/wal-g /usr/local/bin/wal-g

COPY load.sh /usr/local/bin/load.sh
COPY backup.sh /usr/local/bin/backup.sh
COPY standby.sh /usr/local/bin/standby.sh
