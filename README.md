# labo

laboratory docker image for developper


## pull

```
docker pull getto/labo
```

* Docker Hub : [getto/labo](https://hub.docker.com/r/getto/labo/)


## run

```
docker run -d ¥
  --name getto-labo ¥
  -h getto-labo ¥
  -p $PORT:22 ¥
  -e LABO_USER=$LABO_USER
  -e LABO_TIMEZONE=$TIMEZONE
  -v dotfiles:/home/$LABO_USER/.dotfiles ¥
  getto/labo
```

* `LABO_USER` : your working username
* `LABO_TIMEZONE` : Asia/Tokyo, etc.

all container's env put in /env/labo-env

### volume : dotfiles

setup your dotfiles

```
git clone https://github.com/shun-getto-systems/configfiles.git .dotfiles/.config
```

* all `.dotfiles/*` file and directories `ln -s` to $HOME


## build

```
docker build -t getto/labo .
```

# setup on CoreOS

## cloud-config

```yml
#cloud-config

coreos:
  units:
    - name: docker-tcp.socket
      command: start
      enable: true
      content: |
        [Unit]
        Description=Docker Socket for the API

        [Socket]
        ListenStream=2375
        BindIPv6Only=both
        Service=docker.service

        [Install]
        WantedBy=sockets.target
    - name: docker.service
      command: start
```

* **google cloud** : metadata : key=user-data, value=`paste user-data above`


## run base container as service

```
docker swarm init
docker service create ¥
  --name getto-labo ¥
  -p $PORT:22 ¥
  -e DOCKER_HOST=tcp://172.17.0.1:2375 ¥
  -e LABO_LOCAL_IP=$LOCAL_IP ¥
  -e LABO_USER=$LABO_USER
  -e LABO_TIMEZONE=$TIMEZONE
  --mount type=volume,source=dotfiles,destination=/home/$LABO_USER/.dotfiles ¥
  getto/labo
```

* environment variables put in /etc/labo-env


## update container image

```
docker service update --image getto/labo:<version> getto-labo
```


## when trouble on docker.service

```bash
$ sudo cp -a /var/lib/docker/volumes /path/to/backup/docker-volumes
$ sudo rm -rf /var/lib/docker
$ sudo reboot
```

## when boot failed : Readonly filesystem

* uncheck 'delete boot disk when delete instance'
* delete instance
* create new instance, and attach old disk
* `sudo mount /dev/disk/by-id/google-getto-labo-part9 /mnt/data`
* `sudo cp -a /mnt/data/var/lib/docker/volumes /var/lib/docker/volumes`
* detach old disk
* reboot
