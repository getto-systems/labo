#!/bin/bash

if [ "$1" = "/usr/sbin/sshd" ]; then
  mkdir -p /var/run/sshd
  rm -rf /etc/ssh/ssh_host_*
  dpkg-reconfigure openssh-server
fi

env > /etc/labo-env

if [ -n "$LABO_USER" ]; then
  useradd $LABO_USER
  usermod -aG sudo -s /bin/zsh $LABO_USER
  echo '%sudo	ALL=(ALL:ALL) NOPASSWD: ALL' > /etc/sudoers.d/sudo-nopasswd

  labo_home=/home/$LABO_USER
  mkdir -p $labo_home
  chown $LABO_USER:$LABO_USER -R $labo_home
  sudo -u $LABO_USER bash -c "HOME=$labo_home labo-setup"
fi

if [ -n "$LABO_TIMEZONE" ]; then
  ln -sf /usr/share/zoneinfo/$LABO_TIMEZONE /etc/localtime
fi

exec "$@"
