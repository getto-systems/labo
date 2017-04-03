# labo

laboratory docker image for developper


# build image

```
docker build -t getto/labo.shun .
```


# run image

```
docker volume create --name shared # if not exists
docker run -d --name getto-labo-shun -h getto-labo-shun -p $PORT:22 -v shared:/home/shun/.shared getto/labo.shun
```


# user-data.yml

* docker-tcp.socket : see https://coreos.com/os/docs/latest/customizing-docker.html
* start docker.service

## for google cloud

metadata : key=user-data, value=`paste user-data.yml`
