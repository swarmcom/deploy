#!/bin/sh
# most of it is a direct rip of: https://docs.docker.com/install/linux/docker-ce/ubuntu/#set-up-the-repository
apt-get -y update
apt-get -y install apt-transport-https ca-certificates curl lvm2 git ngrep tcpdump net-tools sudo
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt-get -y update
apg-get -y install docker-ce

systemctl start docker

# setup reach3 user, repo and folder structure
adduser ezuce
usermod -a -G docker ezuce
mkdir -p /home/ezuce/keys
mkdir -p /home/ezuce/keys-challenge/.well-known/acme-challenge
cd /home/ezuce
git clone https://github.com/swarmcom/deploy
chown ezuce:ezuce -R /home/ezuce
echo "%ezuce ALL=(root) NOPASSWD:/sbin/iptables" > /etc/sudoers.d/ezuce
echo Login now as ezuce to continue set up
