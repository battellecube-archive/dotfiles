FROM cube-tools

COPY bootstrap /bootstrap
RUN chmod +x /bootstrap

ENTRYPOINT ["/bootstrap"]
RUN useradd -m qb && \
    echo "qb:qb" | chpasswd && \
    adduser qb sudo

USER qb
WORKDIR /home/qb

