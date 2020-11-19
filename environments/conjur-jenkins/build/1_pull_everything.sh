apt-get update
apt-get upgrade -y

docker pull jenkins/jenkins:lts

docker pull postgres:9.3
docker pull conjurinc/cli5
docker pull cyberark/conjur
docker pull python:2.7

cd /tmp
git clone https://github.com/quincycheng/katacoda-env-conjur-jenkins.git


apt-get upgrade -y
