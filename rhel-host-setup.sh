#!/bin/sh
yum -y update
yum -y install yum-utils device-mapper-persistent-data lvm2 git ngrep tcpdump net-tools sudo
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum -y install docker-ce
systemctl start docker
adduser ezuce
usermod -a -G docker ezuce
mkdir -p /home/ezuce/keys
mkdir -p /home/ezuce/keys-challenge/.well-known/acme-challenge
cd /home/ezuce
git clone https://github.com/swarmcom/deploy
chown ezuce:ezuce -R /home/ezuce
echo "%ezuce ALL=(root) NOPASSWD:/sbin/iptables" > /etc/sudoers.d/ezuce
echo Login now as ezuce to continue set up
