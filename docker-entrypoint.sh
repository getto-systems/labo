#!/bin/bash

if [ "$1" = "/usr/sbin/sshd" ]; then
	mkdir -p /var/run/sshd
fi

env | grep "^DOCKER_" > /etc/docker-env

exec "$@"
