# labo.shun

laboratory docker image for developper


## pull

```
docker pull getto/labo.$LABO_USER
```

* Docker Hub : [getto/labo.shun](https://hub.docker.com/r/getto/labo.shun/)


## run

```
docker run -d ¥
  --name getto-labo ¥
  -h getto-labo ¥
  -p $PORT:22 ¥
  -v dotfiles:/home/$LABO_USER/.dotfiles ¥
  getto/labo.$LABO_USER
```

* /env/labo-env : container's env

### volume : dotfiles

setup your dotfiles

```
git clone https://github.com/shun-getto-systems/configfiles.git .dotfiles/.config
```


## build

```
docker build -t getto/labo.$LABO_USER --build-arg LABO_USER=$LABO_USER .
```

* LABO_USER : default : shun

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
  --mount type=volume,source=dotfiles,destination=/home/$LABO_USER/.dotfiles ¥
  getto/labo.$LABO_USER
```

* environment variables put in /etc/labo-env


## update container image

```
docker service update --image getto/labo.$LABO_USER:<version> getto-labo
```


## when trouble on docker.service

```bash
$ sudo cp -a /var/lib/docker/volumes /path/to/backup/docker-volumes
$ sudo rm -rf /var/lib/docker
$ sudo reboot
```
