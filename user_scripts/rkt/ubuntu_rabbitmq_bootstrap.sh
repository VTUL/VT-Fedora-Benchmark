#!/usr/bin/env bash
RABBITMQ_URL="localhost"
RABBITMQ_USERNAME="admin"
RABBITMQ_PASSWORD="admin"
RKT_VERSION="1.25.0"

wget "https://github.com/coreos/rkt/releases/download/v${RKT_VERSION}/rkt-v${RKT_VERSION}.tar.gz"
tar xzvf rkt-v${RKT_VERSION}.tar.gz
mv rkt-v${RKT_VERSION} /usr/local/lib/
ln -s /usr/local/lib/rkt-v${RKT_VERSION}/rkt /usr/bin/rkt
rm rkt-v${RKT_VERSION}.tar.gz

sudo rkt --insecure-options=image run --set-env=RABBITMQ_DEFAULT_USER=${RABBITMQ_USERNAME} --set-env=RABBITMQ_DEFAULT_PASS=${RABBITMQ_PASSWORD} --net=host --hostname=${RABBITMQ_URL} docker://rabbitmq:management
