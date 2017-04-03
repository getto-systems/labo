# labo

laboratory docker image for developper


# build image

```
docker build -t getto/labo.shun:0.0.1 .
```


# run image

```
docker volume create --name shared
docker run --name getto-labo-shun -v shared:/home/shun/.shared getto/labo.shun:0.0.1
```


# user-data.yml

* docker-tcp.socket : see https://coreos.com/os/docs/latest/customizing-docker.html
* start docker.service

## for google cloud

metadata : key=user-data, value=`paste user-data.yml`
