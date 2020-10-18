#!/bin/ash

# docker run -e PSK=<your_psk_here> -p<your_host_port_here>:9102 --restart unless-stopped -d snell-server:latest

BIN="/usr/local/bin/snell-server"
CONF="/etc/snell-server.conf"

# reuse existing config when the container restarts

run_bin() {
    echo "Running snell-server with config:\n"
    cat ${CONF}

    ${BIN} --version
    ${BIN} -c ${CONF}
}

if [ -f ${CONF} ]; then
    echo "Found existing config, rm it."
    rm ${CONF}
fi

if [ -z ${PSK} ]; then
    PSK=$(tr -dc A-Za-z0-9 </dev/urandom | head -c 16)
    echo "Using generated PSK: ${PSK}"
else
    echo "Using predefined PSK: ${PSK}"
fi

if [ -z ${OBFS} ]; then
    PORT=32423
fi

if [ -z ${PORT} ]; then
    PSK=$(tr -dc A-Za-z0-9 </dev/urandom | head -c 16)
fi

echo "Generating new config..."
echo "[snell-server]" >> ${CONF}
echo "listen = 0.0.0.0:${PORT}" >> ${CONF}
echo "psk = ${PSK}" >> ${CONF}
echo "obfs = ${OBFS}" >> ${CONF}

run_bin
