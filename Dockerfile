FROM ubuntu:16.04
MAINTAINER shun

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


RUN : \
 && useradd shun \
 && usermod -aG sudo -s /bin/zsh shun \
 && echo '%sudo	ALL=(ALL:ALL) NOPASSWD: ALL' > /etc/sudoers.d/sudo-nopasswd \
 && mkdir -p /home/shun/.ssh \
 && touch /home/shun/.ssh/authorized_keys \
 && chown shun:shun -R /home/shun \
 && chmod 700 /home/shun/.ssh \
 && chmod 600 /home/shun/.ssh/authorized_keys \
 && :


RUN : \
 && set -x \
 && apt-get install -y \
      apt-transport-https \
      ca-certificates \
 && apt-get clean \
 && :

RUN : \
 && apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D \
 && echo "deb https://apt.dockerproject.org/repo ubuntu-xenial main" > /etc/apt/sources.list.d/docker.list \
 && apt-get update \
 && apt-get install -y \
      docker-engine \
 && apt-get clean \
 && :


RUN : \
 && set -x \
 && apt-get install -y \
      software-properties-common \
 && apt-get clean \
 && add-apt-repository ppa:neovim-ppa/unstable \
 && apt-get update \
 && apt-get install neovim \
 && :

COPY bin /home/shun/bin

USER shun
WORKDIR /home/shun
RUN HOME=/home/shun /home/shun/bin/development-environment-setup


COPY docker-entrypoint.sh /usr/local/bin

USER root
RUN ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
ENV LANG ja_JP.UTF-8
EXPOSE 22

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["/usr/sbin/sshd","-D"]
