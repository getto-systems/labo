# labo

laboratory docker image for developper


## pull

```
docker pull getto/labo.shun
```

* Docker Hub : [getto/labo.shun](https://hub.docker.com/r/getto/labo.shun/)


## run

```
docker run -d --name getto-labo -h getto-labo -p $PORT:22 -v shared:/home/shun/.shared getto/labo.shun
```

* /env/docker-env : env variables

### volume : shared

setup your dotfiles

#### shared/.config

```
git clone https://github.com/shun-getto-systems/configfiles.git .shared/.config
```


## build

```
docker build -t getto/labo.shun .
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

### for google cloud

metadata : key=user-data, value=`paste user-data.yml`


## run base container as service

```
docker swarm init
docker service create ¥
  --name getto-labo ¥
  -p $PORT:22 ¥
  -e DOCKER_LOCAL_IP=$LOCAL_IP ¥
  --mount type=volume,source=shared,destination=/home/shun/.shared ¥
  getto/labo.shun
```

* `DOCKER_${ENV}` : any env vars put in /etc/docker-env


## update container image

```
docker service update --image getto/labo.shun:1.1.1 getto-labo
```
