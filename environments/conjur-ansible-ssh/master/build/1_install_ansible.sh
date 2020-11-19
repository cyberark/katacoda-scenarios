apt-get update
apt-add-repository --yes --update ppa:ansible/ansible
apt-get install ansible sshpass -y
export ANSIBLE_HOST_KEY_CHECKING=False
