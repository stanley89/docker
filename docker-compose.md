# Docker compose

```bash
sudo docker-compose -f definition.yaml up -d
```

## docker-compose.yaml

Je soubor, kterým se konfiguruje celá struktura containerů:

```yaml
version: '2'

services:
  redmine-db:
    image: mariadb:latest
    restart: always
    environment:
      MYSQL_DATABASE: redmine
      MYSQL_USER: redmine
      MYSQL_PASSWORD: redmine
      MYSQL_ROOT_PASSWORD: redmine
    volumes:
      - redmine-db:/var/lib/mysql
  redmine:
    depends_on:
      - redmine-db
    image: sameersbn/redmine:3.3.2-1
    restart: always
    ports:
      - 3000:80
    environment:
      REDMINE_PORT: 3000
      REDMINE_HTTPS: 0
      DB_TYPE: mysql
      DB_ADAPTER: mysql2
      DB_HOST: redmine-db
      DB_NAME: redmine
      DB_USER: redmine
      DB_PASS: redmine
    volumes:
      - redmine-data:/home/redmine/data
      - redmine-logs:/var/log/redmine
```

