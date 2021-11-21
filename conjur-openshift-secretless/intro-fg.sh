#!/bin/bash 
git clone https://github.com/quincycheng/katacoda-secretless-files.git > /dev/null 2>&1
dnf install -y words nano &>/dev/null &
printf " conjur-oss-ingress-conjur-server.apps-crc.testing" >> /etc/hosts
launch.sh
cd katacoda-secretless-files/ 
