#!/usr/bin/env bash

sudo docker run --rm -ti --name redmine2 \
  --net rednet --net-alias redmine \
  -p 3000:80 --env='REDMINE_PORT=3000' \
  --env='DB_TYPE=mysql' --env='DB_ADAPTER=mysql2' \
  --env="DB_HOST=mariadb" --env='DB_NAME=redmine' --env='DB_USER=redmine' --env='DB_PASS=redmine' \
  --volumes-from=redmine \
  sameersbn/redmine:3.3.2-1   app:rake redmine:plugins:migrate NAME=custom_menu VERSION=0
~                               
