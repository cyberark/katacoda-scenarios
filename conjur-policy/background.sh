#!/bin/bash

docker kill root_conjur_1
docker rm root_conjur_1

cd /root
docker-compose up -d