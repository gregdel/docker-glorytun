#!/bin/sh

# The key is the only required parameter
if [ -z "${GLORYTUN_KEY}" ]; then
    echo "missing key"
    exit 1
fi

keyfile=/run/glorytun.key
echo ${GLORYTUN_KEY} > ${keyfile}

# Default values
: ${GLORYTUN_MTU:=1450}
: ${GLORYTUN_TXQLEN:=1000}
: ${GLORYTUN_DEV:=tun0}
: ${GLORYTUN_IP_LOCAL:=10.0.0.1}
: ${GLORYTUN_IP_PEER:=10.0.0.2}
: ${GLORYTUN_PORT:=5000}

echo "Configuring ${GLORYTUN_DEV}"
ip tuntap add ${GLORYTUN_DEV} mode tun
ip addr add ${GLORYTUN_IP_LOCAL} peer ${GLORYTUN_IP_PEER} dev ${GLORYTUN_DEV}
ip link set ${GLORYTUN_DEV} mtu ${GLORYTUN_MTU}
ip link set ${GLORYTUN_DEV} txqueuelen ${GLORYTUN_TXQLEN}
ip link set ${GLORYTUN_DEV} up
echo "Configuration done"

iptables -w -t nat -A POSTROUTING -o eth0 -s ${GLORYTUN_IP_PEER} -j MASQUERADE

/usr/sbin/glorytun dev ${GLORYTUN_DEV} bind-port ${GLORYTUN_PORT} mtu ${GLORYTUN_MTU} keyfile ${keyfile} v4only
