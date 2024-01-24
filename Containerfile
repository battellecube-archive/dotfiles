FROM ubuntu as base

ENV DEBIAN_FRONTEND=noninteractive
ENV APT_LISTCHANGES_FRONTEND=none
ENV APT_LISTBUGS_FRONTEND=none

RUN echo 'tzdata tzdata/Areas select America' | debconf-set-selections && \
    echo 'tzdata tzdata/Zones/America select New_York' | debconf-set-selections

RUN apt update && apt install -y --no-install-recommends \
    ca-certificates \
    curl \
    gosu \
    make \
    sudo \
    tzdata \
    ubuntu-minimal && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

FROM base as tools

COPY Makefile .
RUN make all

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
