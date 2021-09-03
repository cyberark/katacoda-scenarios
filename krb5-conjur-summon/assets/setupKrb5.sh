docker-compose -f docker-compose-krb5.yml up -d 
apt-get update
DEBIAN_FRONTEND=noninteractive apt-get install -y krb5-user
