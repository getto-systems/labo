#!/bin/bash

if [ "$1" = "/usr/sbin/sshd" ]; then
  mkdir -p /var/run/sshd
  rm -rf /etc/ssh/ssh_host_*
  ssh-keygen -f /etc/ssh/ssh_host_rsa_key -N '' -t rsa
  ssh-keygen -f /etc/ssh/ssh_host_dsa_key -N '' -t dsa
fi

env > /etc/labo-env

if [ -n "$LABO_USER" ]; then
  useradd $LABO_USER
  usermod -aG sudo -s /bin/zsh $LABO_USER
  echo "$LABO_USER:$LABO_USER" | chpasswd

  labo_home=/home/$LABO_USER
  mkdir -p $labo_home
  chown $LABO_USER:$LABO_USER -R $labo_home
  sudo -u $LABO_USER bash -c "HOME=$labo_home labo-setup"
fi

if [ -n "$LABO_TIMEZONE" ]; then
  ln -sf /usr/share/zoneinfo/$LABO_TIMEZONE /etc/localtime
fi

exec "$@"
