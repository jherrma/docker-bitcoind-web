ARG DEBIAN_VERSION=12-slim
ARG GO_VERSION=1.22

FROM debian:${DEBIAN_VERSION} AS builder

ARG TARGETARCH

FROM builder AS builder_amd64
ENV ARCH=x86_64
FROM builder AS builder_arm64
ENV ARCH=aarch64

FROM builder_${TARGETARCH} AS build

ARG BITCOIN_CORE_SIGNATURE=71A3B16735405025D447E8F274810B012346C9A6
ARG VERSION=28.1

RUN apt update \
    && apt install -y --no-install-recommends \
    ca-certificates \
    gnupg \
    libatomic1 \
    wget \
    && apt clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN cd /tmp \
    && gpg --keyserver hkp://keyserver.ubuntu.com --recv-keys ${BITCOIN_CORE_SIGNATURE} \
    && wget https://bitcoincore.org/bin/bitcoin-core-${VERSION}/SHA256SUMS.asc \
    https://bitcoincore.org/bin/bitcoin-core-${VERSION}/SHA256SUMS \
    https://bitcoincore.org/bin/bitcoin-core-${VERSION}/bitcoin-${VERSION}-${ARCH}-linux-gnu.tar.gz \
    && gpg --verify --status-fd 1 --verify SHA256SUMS.asc SHA256SUMS 2>/dev/null | grep "^\[GNUPG:\] VALIDSIG.*${BITCOIN_CORE_SIGNATURE}\$" \
    && sha256sum --ignore-missing --check SHA256SUMS \
    && tar -xzvf bitcoin-${VERSION}-${ARCH}-linux-gnu.tar.gz -C /opt \
    && ln -sv bitcoin-${VERSION} /opt/bitcoin \
    && rm -v /opt/bitcoin/bin/test_bitcoin /opt/bitcoin/bin/bitcoin-qt


FROM golang:${GO_VERSION} AS server
WORKDIR /bitcoin
COPY docker-bitcoin-server .
RUN go mod download
RUN CGO_ENABLED=0 GOOS=linux go build -o docker-bitcoin-server


FROM debian:${DEBIAN_VERSION} AS final

ENV HOME /bitcoin
ARG RPCALLOWIP=127.0.0.1
ARG RPCBIND=8332
EXPOSE 8332
EXPOSE 8080
WORKDIR /bitcoin
RUN mkdir -p /bitcoin/.bitcoin

ARG GROUP_ID=1000
ARG USER_ID=1000
RUN groupadd -g ${GROUP_ID} bitcoin \
    && useradd -u ${USER_ID} -g bitcoin -d /bitcoin bitcoin

COPY --from=build /opt/ /opt/

RUN apt update \
&& apt install -y --no-install-recommends gosu libatomic1 \
&& apt clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
&& ln -sv /opt/bitcoin/bin/* /usr/local/bin

COPY --from=server /bitcoin/docker-bitcoin-server /bitcoin/docker-bitcoin-server

# Frontend needs to be compiled locally before running docker build
COPY dockerbitcoinfrontend/build/web /bitcoin/frontend

ENTRYPOINT ["/bitcoin/docker-bitcoin-server"]
