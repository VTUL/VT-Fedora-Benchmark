#!/usr/bin/env bash
RABBITMQ_URL=
RABBITMQ_USERNAME="admin"
RABBITMQ_PASSWORD="admin"

sudo yum -y install \
    curl \
    git \
    ntp \
    vim \
    wget
git clone https://github.com/VTUL/VT-Fedora-Benchmark.git vt-fedora-benchmark
ln -s vt-fedora-benchmark/orchestrators/docker_orchestrator.py collector.py

curl -fsSL https://get.docker.com/ | sh
sudo service docker start

docker pull dedocibula/fedora-benchmark

wget https://bootstrap.pypa.io/get-pip.py
sudo python get-pip.py
sudo pip install pika
sudo pip install supervisor
rm get-pip.py

echo "[program:docker_orchestrator]" >> /etc/supervisord.conf
echo "command=nice -n -5 python docker_orchestrator.py start_with ${RABBITMQ_URL} ${RABBITMQ_USERNAME} ${RABBITMQ_PASSWORD} False" >> /etc/supervisord.conf
echo "directory=${PWD}/vt-fedora-benchmark/orchestrators" >> /etc/supervisord.conf
echo "redirect_stderr=true" >> /etc/supervisord.conf
echo "stdout_logfile=${PWD}/vt-fedora-benchmark/orchestrators/experiment.out" >> /etc/supervisord.conf
echo "autostart=true" >> /etc/supervisord.conf
echo "autorestart=unexpected" >> /etc/supervisord.conf

supervisorctl reread && supervisorctl update
