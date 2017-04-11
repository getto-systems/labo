FROM ubuntu:16.10
MAINTAINER shun

EXPOSE 22

ENV LSB_RELEASE yakkety

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
      software-properties-common \
      ssh \
      sudo \
      tmux \
      unzip \
      zsh \
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

# entrypoint, setup script
COPY docker-entrypoint.sh labo-setup /usr/local/bin/

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["/usr/sbin/sshd","-D"]
