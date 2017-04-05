# labo

laboratory docker image for developper


## run container

```
docker run -d --name getto-labo -h getto-labo -p $PORT:22 -v shared:/home/shun/.shared getto/labo.shun
```

* Docker Hub : [getto/labo.shun](https://hub.docker.com/r/getto/labo.shun/)

### init container

```
docker exec -u shun:shun getto-labo /home/shun/bin/labo-setup
```

### setup shared

```
docker volume create --name shared
docker run -it -v shared:/home/shun/.shared getto/labo.shun bash
$ sudo chown shun:shun .shared
```

#### shared/.config

```
git clone https://github.com/shun-getto-systems/configfiles.git .shared/.config
```


## build image

```
docker build -t getto/labo.shun .
```


## user-data.yml

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
users:
  - name: "shun"
    ssh-authorized-keys:
      - "ssh-rsa ..."
```

### for google cloud

metadata : key=user-data, value=`paste user-data.yml`
