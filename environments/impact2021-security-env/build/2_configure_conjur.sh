#!/bin/bash

# Download the cybr-cli
docker run --name cybr-cli -d --network conjur \
    --entrypoint sleep \
    nfmsjoeg/cybr-cli:0.1.3-beta infinity
docker cp cybr-cli:/app/cybr /usr/local/bin

# Get Policy files
mkdir /root/policies
git clone https://github.com/infamousjoeg/katacoda-scenarios.git
cp katacoda-scenarios/impact2021-security-workshop_webapp/assets/root.yml /root/policies/root.yml