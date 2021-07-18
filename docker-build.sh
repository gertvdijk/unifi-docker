#!/usr/bin/env bash

# fail on error
set -e

if [ "x${PKGURL}" == "x" ]; then
    echo please pass PKGURL as an environment variable
    exit 0
fi

apt-get update
apt-get install -qy --no-install-recommends \
    ca-certificates \
    curl \
    dirmngr \
    gosu \
    openjdk-8-jre-headless \
    procps \
    libcap2-bin \
    tzdata

if [ -d "/usr/local/docker/pre_build/$(dpkg --print-architecture)" ]; then
    run-parts "/usr/local/docker/pre_build/$(dpkg --print-architecture)"
fi

curl -L -o ./unifi.deb "${PKGURL}"
apt -qy install ./unifi.deb
rm -f ./unifi.deb
chown -R unifi:unifi /usr/lib/unifi
rm -rf /var/lib/apt/lists/*

rm -rf ${ODATADIR} ${OLOGDIR}
mkdir -p ${DATADIR} ${LOGDIR}
ln -s ${DATADIR} ${BASEDIR}/data
ln -s ${RUNDIR} ${BASEDIR}/run
ln -s ${LOGDIR} ${BASEDIR}/logs
rm -rf {$ODATADIR} ${OLOGDIR}
ln -s ${DATADIR} ${ODATADIR}
ln -s ${LOGDIR} ${OLOGDIR}
mkdir -p /var/cert ${CERTDIR}
ln -s ${CERTDIR} /var/cert/unifi
