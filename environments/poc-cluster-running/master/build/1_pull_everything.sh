#Ansible
apt-get update
apt-add-repository --yes --update ppa:ansible/ansible
apt-get install ansible sshpass -y
apt install -y wamerican
apt-get upgrade -y

export ANSIBLE_HOST_KEY_CHECKING=False

#Conjur
curl -o docker-compose.yml https://quincycheng.github.io/docker-compose.quickstart.yml
docker-compose pull
docker-compose run --no-deps --rm conjur data-key generate > data_key

docker pull postgres:9.6


#Jenkins
docker pull jenkins/jenkins:lts

#Kubernetes
cd /tmp
git clone https://github.com/QuincyChengAtWork/conjur-oss-k8s-authn-katacoda.git
wget https://github.com/QuincyChengAtWork/conjur-oss-k8s-authn-katacoda/archive/v1.0.zip
unzip v1.0.zip

# Add service01 a/c
useradd -m -d /tmp service01
echo 'service01:W/4m=cS6QSZSc*nd' | chpasswd
