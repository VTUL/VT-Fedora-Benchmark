#!/usr/bin/env bash
RABBITMQ_URL=
RABBITMQ_USERNAME="admin"
RABBITMQ_PASSWORD="admin"
RKT_VERSION="1.25.0"

sudo apt-get update && sudo apt-get install -y \
    curl \
    git \
    ntp \
    vim \
    wget
git clone https://github.com/VTUL/VT-Fedora-Benchmark.git vt-fedora-benchmark
ln -s vt-fedora-benchmark/orchestrators/rkt_orchestrator.py collector.py

wget "https://github.com/coreos/rkt/releases/download/v${RKT_VERSION}/rkt-v${RKT_VERSION}.tar.gz"
tar xzvf rkt-v${RKT_VERSION}.tar.gz
mv rkt-v${RKT_VERSION} /usr/local/lib/
ln -s /usr/local/lib/rkt-v${RKT_VERSION}/rkt /usr/bin/rkt
rm rkt-v${RKT_VERSION}.tar.gz

sudo rkt --insecure-options=image fetch docker://dedocibula/fedora-benchmark

wget https://bootstrap.pypa.io/get-pip.py
sudo python get-pip.py
sudo pip install pika
sudo pip install supervisor
rm get-pip.py

echo_supervisord_conf > /etc/supervisord.conf
echo "[program:rkt_orchestrator]" >> /etc/supervisord.conf
echo "command=nice -n -5 python rkt_orchestrator.py start_with ${RABBITMQ_URL} ${RABBITMQ_USERNAME} ${RABBITMQ_PASSWORD} /vt-fedora-benchmark/experiments/results False" >> /etc/supervisord.conf
echo "directory=${PWD}/vt-fedora-benchmark/orchestrators" >> /etc/supervisord.conf
echo "redirect_stderr=true" >> /etc/supervisord.conf
echo "stdout_logfile=${PWD}/vt-fedora-benchmark/orchestrators/experiment.out" >> /etc/supervisord.conf
echo "autostart=true" >> /etc/supervisord.conf
echo "autorestart=unexpected" >> /etc/supervisord.conf

supervisord
