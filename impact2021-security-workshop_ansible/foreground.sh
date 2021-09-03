#!/bin/bash
set +H
clear && printf "Verifying environment...\n- Ansible..." && sleep 1s && timeout 30s bash -c 'while ! [ -f /root/insecure-playbook/insecure-playbook.yml ];do printf ".";sleep 2s;done'  && printf "☑️\n- Conjur..." && timeout 60s bash -c 'while [ "$(docker ps -a|grep conjur_conjur_1)" = "" ];do printf ".";sleep 2s;done'   && echo -e "☑️\n- Ready! 😀"
