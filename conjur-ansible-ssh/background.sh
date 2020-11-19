rm * -rf 
git clone https://github.com/quincycheng/katacoda-env-conjur-ansible-ssh.git 
mv katacoda-env-conjur-ansible-ssh/* .
chmod +x conjur/setupConjur.sh
cd conjur
./setupConjur.sh 
cd ..
