FROM alpine:3.4

# Install iproute2
RUN apk add --no-cache iproute2

# Add the glorytun launch script
ADD glorytun.sh /usr/sbin/glorytun.sh

# Glorytun version 0.0.55-mud
ENV version 0.0.89-mud
ADD https://github.com/angt/glorytun/releases/download/v${version}/glorytun-${version}-x86_64.bin  /usr/sbin/glorytun
RUN chmod +x /usr/sbin/glorytun

CMD /usr/sbin/glorytun.sh
