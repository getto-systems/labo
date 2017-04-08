#!/bin/bash

if [ "$1" = "/usr/sbin/sshd" ]; then
  mkdir -p /var/run/sshd
  rm -rf /etc/ssh/ssh_host_*
  dpkg-reconfigure openssh-server
fi

env | grep "^DOCKER_" > /etc/docker-env

sudo -u $LABO_USER bash -c "HOME=/home/$LABO_USER /home/$LABO_USER/bin/labo-setup"

exec "$@"
