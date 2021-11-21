#!/bin/bash 
truncate -s -1 /etc/hosts
printf " conjur-oss-conjur-server.apps-crc.testing" >> /etc/hosts
git clone https://github.com/quincycheng/katacoda-secretless-files.git > /dev/null 2>&1
dnf install -y words nano &>/dev/null &

launch.sh
cd katacoda-secretless-files/ 
