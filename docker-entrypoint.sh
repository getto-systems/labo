#!/bin/bash

if [ "$1" = "/usr/sbin/sshd" ]; then
  mkdir -p /var/run/sshd
  rm -rf /etc/ssh/ssh_host_*
  dpkg-reconfigure openssh-server
fi

env | grep "^DOCKER_" > /etc/docker-env

sudo -u shun /home/shun/bin/labo-setup

exec "$@"
