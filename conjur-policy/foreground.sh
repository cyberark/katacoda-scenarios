#!/bin/bash
set +H
clear && printf "Verifying environment..." && sleep 3s && timeout 90s bash -c 'while ! docker exec root_client_1 conjur list >/dev/null 2>&1;do printf ".";sleep 1s;done' && echo -e "\nReady!"
