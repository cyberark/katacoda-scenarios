#!/bin/bash

refresh_token=$(curl -s --user admin:$conjur_admin ${conjur_url}authn/demo/login)
response=$(curl -s -X POST ${conjur_url}authn/demo/admin/authenticate -d ${refresh_token})
export access_token=$(echo -n $response | base64 | tr -d '\r\n')

c0="\e[39m"
c1="\e[32m"
c2="\e[96m"

echo -e "${c1}Conjur URL: ${c2}"$conjur_url
echo -e "${c1}Conjur Org: ${c2}demo"
echo -e "${c1}Conjur User Name: ${c2}admin"
echo -e "${c1}Conjur Password: ${c2}"$conjur_admin
echo -e "${c1}Conjur API Key: ${c2}"$refresh_token
echo -e "${c1}Conjur Access Token: ${c2}"$access_token
echo -e "${c0}"

