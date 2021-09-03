#!/bin/bash

docker start lamp

docker kill root_conjur_1
docker rm root_conjur_1

cd /root
docker-compose up -d

/opt/start-vscode.sh /opt/app &

#/opt/vscode/node /opt/vscode/out/node/entry.js --host=0.0.0.0 --port=23000 --disable-ssh --auth=none --disable-telemetry --disable-updates --extensions-dir=/opt/.katacodacode/extensions/ --user-data-dir=/opt/.katacodacode/user-data &

#echo "done" >> /root/katacoda-finished
#echo "done" >> /root/katacoda-background-finished
