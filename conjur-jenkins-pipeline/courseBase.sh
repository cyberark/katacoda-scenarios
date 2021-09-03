#!/bin/bash

# clean up, dev only, should be done in image
rm -rf *
git clone https://github.com/quincycheng/katacoda-env-conjur-jenkins.git

cd katacoda-env-conjur-jenkins

export CONJUR_DATA_KEY="$(docker-compose run --no-deps --rm conjur data-key generate)"
docker-compose up -d 

echo "$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' conjur_conjur_1) conjur" >> /etc/hosts
