#!/usr/bin/env bash
RABBITMQ_URL="rabbit-mq"
RABBITMQ_USERNAME="admin"
RABBITMQ_PASSWORD="admin"

curl -fsSL https://get.docker.com/ | sh

docker run -d -p 5672:5672 -p 15672:15672  --hostname ${RABBITMQ_URL} --name ${RABBITMQ_URL} -e RABBITMQ_DEFAULT_USER=${RABBITMQ_USERNAME} -e RABBITMQ_DEFAULT_PASS=${RABBITMQ_PASSWORD} rabbitmq:management
