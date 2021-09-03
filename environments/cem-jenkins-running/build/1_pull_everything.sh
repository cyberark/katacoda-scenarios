#Ansible
apt-get update
apt-get upgrade -y

#Jenkins
docker pull jenkins/jenkins:lts-jdk11

# Download, combine & unpack jenkins_data folder
cd /opt
git clone https://github.com/quincycheng/katacoda-env-cem-jenkins.git
cd /opt/katacoda-env-cem-jenkins/
cat assets/jenkins_data.tar.gz.parta* > jenkins_data.tar.gz
tar zvxf jenkins_data.tar.gz
rm jenkins_data.tar.gz

# Script to start jenkins when session starts
cat << EOF > /opt/configure-environment.sh
#!/bin/bash
cd /opt/katacoda-env-cem-jenkins/
docker-compose up -d
EOF
chmod +x /opt/configure-environment.sh
