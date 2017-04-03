FROM ubuntu:16.10
MAINTAINER shun

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
      ssh \
      sudo \
      unzip \
      zsh \
 && apt-get clean \
 && :

# setup localtime
RUN ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

# setup home
RUN : \
 && useradd shun \
 && usermod -aG sudo -s /bin/zsh shun \
 && echo '%sudo	ALL=(ALL:ALL) NOPASSWD: ALL' > /etc/sudoers.d/sudo-nopasswd \
 && mkdir -p /home/shun/.ssh \
 && mkdir -p /home/shun/bin \
 && touch /home/shun/.ssh/authorized_keys \
 && chown shun:shun -R /home/shun \
 && chmod 700 /home/shun/.ssh \
 && chmod 600 /home/shun/.ssh/authorized_keys \
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
 && apt-get install neovim \
 && apt-get clean \
 && :

COPY docker-entrypoint.sh /usr/local/bin
COPY labo-setup /home/shun/bin

USER shun
RUN /home/shun/bin/labo-setup

USER root

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["/usr/sbin/sshd","-D"]
