rm * -rf 
docker kill conjur_conjur_1
docker rm conjur_conjur_1
git clone https://github.com/quincycheng/katacoda-env-conjur-ansible-ssh.git 
mv katacoda-env-conjur-ansible-ssh/* .
chmod +x conjur/setupConjur.sh
cd conjur
./setupConjur.sh 
cd ..
