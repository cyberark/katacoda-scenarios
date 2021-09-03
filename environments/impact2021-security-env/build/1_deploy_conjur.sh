#!/bin/bash

#debug
echo "*** Start of impact2021-security-env ***"


docker pull mattrayner/lamp:latest-1804
docker pull nfmsjoeg/cybr-cli:0.1.3-beta
docker pull captainfluffytoes/csme:latest
docker pull cyberark/conjur-cli:5-latest

docker network create conjur
docker run --name conjur -d --restart always --network conjur --security-opt seccomp:unconfined \
    -p 443:443 -p 444:444 -p 5432:5432 -p 1999:1999 \
    -v /opt/cyberark/conjur/configuration:/opt/cyberark/dap/configuration:Z \
    -v /opt/cyberark/conjur/security:/opt/cyberark/dap/security:Z \
    -v /opt/cyberark/conjur/backup:/opt/cyberark/dap/backup:Z \
    -v /opt/cyberark/conjur/seeds:/opt/cyberark/dap/seeds:Z \
    -v /opt/cyberark/conjur/logs:/var/log/conjur:Z \
    captainfluffytoes/csme:latest
docker exec conjur evoke configure master --accept-eula --hostname host01 --admin-password CYberark11@@ impact2021