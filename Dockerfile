FROM xmrig/xmrig:latest AS xmrig

FROM registry.access.redhat.com/ubi8:latest

LABEL maintainer="pvn@novarese.net"
LABEL name="2021-November-Enterprise-Demo"
LABEL org.opencontainers.image.title="2021-November-Enterprise-Demo"
LABEL org.opencontainers.image.description="Simple image to test various policy rules with Anchore Enterprise."

##if you need to use the actual rpm rather than the hints file, use this COPY and comment out the other one
##COPY Dockerfile sudo-1.8.29-5.el8.x86_64.rpm ./
COPY Dockerfile anchore_hints.json ./

RUN set -ex && \
    adduser -d /xmrig mining && \
    echo "aws_access_key_id=01234567890123456789" > /aws_access && \
    echo "-----BEGIN OPENSSH PRIVATE KEY-----" > /ssh_key && \
    yum -y install ruby python3-devel python3 python3-pip nodejs && \
    pip3 install --index-url https://pypi.org/simple --no-cache-dir aiohttp==3.7.3 pytest urllib3 botocore six numpy && \
    gem install ftpd -v 0.2.1 && \
    npm install --cache /tmp/empty-cache xmldom@0.4.0 && \
    rm -rf /tmp/empty-cache && \
    npm cache clean --force && \
    yum remove ruby python3-devel python3-pip python3 nodejs -y && \
    yum autoremove -y && \
    yum clean all && \    
    rm -rf /var/cache/yum

## if using the actual rpm rather than the hints file, you need these:
##    yum -y install /sudo-1.8.29-5.el8.x86_64.rpm && \
##    rm -rf /sudo-1.8.29-5.el8.x86_64.rpm && \    

COPY --from=xmrig /xmrig/xmrig /xmrig/xmrig
HEALTHCHECK --timeout=10s CMD /bin/true || exit 1

## just to make sure we have a unique build each time
RUN date > /image_build_timestamp

USER mining
WORKDIR /xmrig
ENTRYPOINT /bin/false
