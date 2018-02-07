#!/bin/sh
yum -y install yum-utils device-mapper-persistent-data lvm2 git ngrep tcpdump net-tools
yum -y update
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum -y install docker-ce
yum -y install docker-ce
systemctl start docker
adduser ezuce
usermod -a -G docker ezuce
mkdir -p /home/ezuce/keys
mkdir -p /home/ezuce/keys-challenge/.well-known/acme-challenge
chown ezuce:ezuce -R /home/ezuce

