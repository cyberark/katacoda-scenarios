#!/bin/bash
clear && printf "Clearing environment..." 
docker kill $(docker ps -aq) 
docker rm $(docker ps -aq)
rm /root/docker-compose.yml
rm /root/admin.out
rm /root/demouser.txt
clear 
