#!/bin/bash

# Start LAMP container with host identity
docker run --name lamp -d --restart always --network conjur -p "80:80" -p "3306:3306" \
    -e CONJUR_AUTHN_LOGIN=admin \
    -e CONJUR_AUTHN_API_KEY=CYberark11@@ \
    -e CONJUR_APPLIANCE_URL=https://conjur \
    -v /opt/app:/app -v /opt/mysql:/var/lib/mysql \
    mattrayner/lamp:latest-1804

sleep 1m
# Add "use conjur_demo"
docker exec lamp mysql -h localhost --port=3306 -uroot \
    -e "CREATE DATABASE conjur_demo;  CREATE USER 'devapp1' IDENTIFIED BY 'Cyberark1'; GRANT ALL PRIVILEGES ON conjur_demo.* TO 'devapp1'; FLUSH PRIVILEGES; USE conjur_demo; CREATE TABLE IF NOT EXISTS conjur_demo.demo (message VARCHAR(255) NOT NULL) ENGINE=MyISAM DEFAULT CHARSET=utf8; INSERT INTO demo (message) VALUES ('If you are seeing this message, we have successfully connected PHP to our backend MySQL database!');"
