FROM golang:1.17 as build

ARG WALG_RELEASE=v1.1

RUN apt-get update -qq && apt-get install -qqy --no-install-recommends --no-install-suggests cmake liblzo2-dev libsodium23 && \
    cd /go/src/ && \
    git clone -b $WALG_RELEASE --recurse-submodules https://github.com/wal-g/wal-g.git && \
    cd wal-g && \
    GOBIN=/go/bin USE_LIBSODIUM=1 USE_LZO=1 make install_and_build_pg


FROM postgres:13

RUN apt-get update  && apt-get install -y \
    libsodium23 \
    curl \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

#    apt-get install -qqy curl ca-certificates libsodium23 vim

COPY --from=build /go/src/wal-g/main/pg/wal-g /usr/local/bin/wal-g

COPY load.sh /usr/local/bin/load.sh
COPY backup.sh /usr/local/bin/backup.sh
