# labo

laboratory docker image for developper


# build image

```
docker build -t getto/labo.shun .
```


# run container

```
docker run -d --name getto-labo -h getto-labo -p $PORT:22 -v shared:/home/shun/.shared getto/labo.shun
```

## setup shared

```
docker volume create --name shared
docker run -it -v shared:/home/shun/.shared getto/labo.shun bash
$ sudo chown shun:shun .shared
```


# user-data.yml

* docker-tcp.socket : see https://coreos.com/os/docs/latest/customizing-docker.html
* start docker.service

## for google cloud

metadata : key=user-data, value=`paste user-data.yml`
