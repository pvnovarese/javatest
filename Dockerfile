FROM registry.access.redhat.com/ubi8:latest

LABEL maintainer="pvn@novarese.net"
LABEL name="2021-November-Enterprise-Demo"
LABEL org.opencontainers.image.title="2021-November-Enterprise-Demo"
LABEL org.opencontainers.image.description="Simple image to test various policy rules with Anchore Enterprise."

COPY Dockerfile /Dockerfile
COPY anchore_hints.json /anchore_hints.json
RUN set -ex && \
    date > /image_build_timestamp && \
    echo "aws_access_key_id=01234567890123456789" > /aws_access && \
    echo "-----BEGIN OPENSSH PRIVATE KEY-----" > /ssh_key && \
    yum autoremove -y && \
    yum clean all && \
    rm -rf /var/cache/yum



USER 65534:65534
HEALTHCHECK CMD /bin/true
CMD /bin/sh
