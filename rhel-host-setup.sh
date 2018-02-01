#!/bin/sh
yum -y install yum-utils device-mapper-persistent-data lvm2 git ngrep tcpdump
yum -y update
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum -y install docker-ce
yum -y install docker-ce
systemctl start docker
adduser ezuce
chown ezuce:ezuce -R /home/ezuce
usermod -a -G docker ezuce
