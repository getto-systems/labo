FROM ubuntu:16.10
MAINTAINER shun

ARG LABO_USER=shun
ENV LABO_USER $LABO_USER

EXPOSE 22

ENV LSB_RELEASE yakkety
ENV LANG ja_JP.UTF-8

# basic packages
RUN : \
 && set -x \
 && apt-get update \
 && apt-get install -y \
      bash-completion \
      curl \
      git \
      language-pack-ja \
      language-pack-ja-base \
      man \
      manpages-dev \
      silversearcher-ag \
      ssh \
      sudo \
      tmux \
      unzip \
      zsh \
 && apt-get clean \
 && :

# setup localtime
RUN ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

# setup home
RUN : \
 && useradd $LABO_USER \
 && usermod -aG sudo -s /bin/zsh $LABO_USER \
 && echo '%sudo	ALL=(ALL:ALL) NOPASSWD: ALL' > /etc/sudoers.d/sudo-nopasswd \
 && mkdir -p /home/$LABO_USER/bin \
 && chown $LABO_USER:$LABO_USER -R /home/$LABO_USER \
 && :

# install add-apt-repository
RUN : \
 && set -x \
 && apt-get install -y \
      software-properties-common \
 && apt-get clean \
 && :

# docker
RUN : \
 && set -x \
 && apt-get install -y \
      apt-transport-https \
      ca-certificates \
 && curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - \
 && sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $LSB_RELEASE stable" \
 && apt-get update \
 && apt-get install -y \
      docker-ce \
 && apt-get clean \
 && :

# install nvim
RUN : \
 && set -x \
 && add-apt-repository ppa:neovim-ppa/unstable \
 && apt-get update \
 && apt-get install -y \
      neovim \
      python3-pip \
 && apt-get clean \
 && pip3 install neovim \
 && :

COPY docker-entrypoint.sh /usr/local/bin
COPY labo-setup /home/$LABO_USER/bin

USER $LABO_USER
RUN /home/$LABO_USER/bin/labo-setup

USER root

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["/usr/sbin/sshd","-D"]
