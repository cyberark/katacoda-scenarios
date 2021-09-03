#!/bin/bash

echo "Start of impact2021-cluster-running env" 
 
# Base OS
apt-get update
apt-get upgrade -y

# Ansible
apt-add-repository --yes --update ppa:ansible/ansible
apt-get update
apt-get install ansible sshpass -y
apt-get install -y wamerican
export ANSIBLE_HOST_KEY_CHECKING=False

# MySQL Client
apt-get install -y mysql-client-core-5.7 jq


# Install Conjur OSS quick-start
mkdir -p /opt/conjur/postgres-data
cd /root

cat <<EOF > docker-compose.yml 
version: '3'
services:
  database:
    image: postgres:10.16
    environment:
      POSTGRES_HOST_AUTH_METHOD: trust
    restart: always

  conjur:
    image: cyberark/conjur
    command: server
    environment:
      DATABASE_URL: postgres://postgres@database/postgres
      CONJUR_DATA_KEY:
    depends_on: [ database ]
    ports:
      - "8080:80"
    volumes:
      - /opt/conjur/postgres-data:/var/lib/postgresql/data
    restart: always
    
  client:
    image: conjurinc/cli5
    depends_on: [ conjur ]
    entrypoint: sleep
    command: infinity
    environment:
      CONJUR_APPLIANCE_URL: http://conjur
      CONJUR_ACCOUNT:
      CONJUR_AUTHN_API_KEY:
      CONJUR_AUTHN_LOGIN: admin
    restart: always
EOF

docker-compose pull
docker-compose run --no-deps --rm conjur data-key generate > data_key
export CONJUR_DATA_KEY="$(< data_key)"
docker-compose up -d 

# Wait until conjur container is running
sleep 1m
docker-compose logs conjur #for debug


# Create Conjur Account & Login as Admin 
docker exec root_conjur_1 conjurctl account create quick-start | tee admin.out
export conjur_admin="$(grep API admin.out | cut -d: -f2 | tr -d ' \r\n')"
docker exec root_client_1 bash -c "echo yes | conjur init -u http://conjur -a quick-start"
docker exec root_client_1 conjur authn login -u admin -p "${conjur_admin}"


# cybr-cli
docker run --name cybr-cli -d nfmsjoeg/cybr-cli:0.1.3-beta
docker cp cybr-cli:/app/cybr /usr/local/bin
docker rm -f cybr-cli


# Deploy LAMP & create MySQL database and user
mkdir /opt/mysql
mkdir /opt/app
cd /opt
docker pull mattrayner/lamp:latest-1804
docker pull nfmsjoeg/cybr-cli:0.1.3-beta

# Get Policy files
git clone https://github.com/infamousjoeg/katacoda-scenarios.git
mkdir /opt/policies/
cp katacoda-scenarios/impact2021-security-workshop_webapp/assets/* /opt/policies


# Copy & load root.yml policy file
docker exec root_client_1 mkdir /policies/
docker cp /opt/policies/root.yml root_client_1:/policies/

# Output API key to /root/demouser.txt
docker exec root_client_1 conjur policy load root /policies/root.yml > /root/demouser.txt

# Initialize devapp secret variables
docker exec root_client_1 conjur variable values add devapp/db_uname devapp1
docker exec root_client_1 conjur variable values add devapp/db_pass Cyberark1

# Grab Conjur authn info
CONJUR_AUTHN_LOGIN=$(docker exec root_client_1 printenv CONJUR_AUTHN_LOGIN)
CONJUR_APPLIANCE_URL=$(docker exec root_client_1 printenv CONJUR_APPLIANCE_URL)
CONJUR_AUTHN_API_KEY=$(docker exec root_client_1 awk 'NR==3 {print $NF}' /root/.netrc)

# Remove old CLI container
#docker rm -f root_client_1

# Start LAMP container with host identity
docker run --name lamp -d -p "80:80" -p "3306:3306" \
    -e CONJUR_AUTHN_LOGIN="$CONJUR_AUTHN_LOGIN" \
    -e CONJUR_AUTHN_API_KEY="$CONJUR_AUTHN_API_KEY" \
    -e CONJUR_APPLIANCE_URL="$CONJUR_APPLIANCE_URL" \
    -v /opt/app:/app -v /opt/mysql:/var/lib/mysql \
    mattrayner/lamp:latest-1804

sleep 1m
# Add "use conjur_demo"
docker exec lamp mysql -h localhost --port=3306 -uroot \
    -e "CREATE DATABASE conjur_demo;  CREATE USER 'devapp1' IDENTIFIED BY 'Cyberark1'; GRANT ALL PRIVILEGES ON conjur_demo.* TO 'devapp1'; FLUSH PRIVILEGES; USE conjur_demo; CREATE TABLE IF NOT EXISTS conjur_demo.demo (message VARCHAR(255) NOT NULL) ENGINE=MyISAM DEFAULT CHARSET=utf8; INSERT INTO demo (message) VALUES ('If you are seeing this message, we have successfully connected PHP to our backend MySQL database!');"



echo "End of impact2021-cluster-running env"
