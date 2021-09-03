#System Update

apt-get update
yes | apt-get upgrade

# add service02 account
useradd -m -d /tmp service02
echo -e "5;LF+J4Rfqds:DZ8\n5;LF+J4Rfqds:DZ8\n" | passwd service02

# Add service01 a/c
useradd -m -d /tmp service01
echo 'service02:5;LF+J4Rfqds:DZ8' | chpasswd
