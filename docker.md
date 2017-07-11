
Docker
======

Je jedním z nejrozšířenějších containerovacích systémů (popř. též os level virtualization). Využívá k tomu základní nástroje obsažené přímo v kernelu Linuxu (namespace, cgroups, ...). V praxi je důležité, že každý container využivá kernel hosta, popř. dokonce i základní knihovny.

Kontejner si nese knihovny a samotnou aplikaci (vlastně se chová jako složitější binárka, třeba jako na os X). Tím pádem nám odpadají různá dependecy hell. Např. kompilování nativ modulů v Pythonu a instalace přesných verzí z pipu.

Kontejnery mají vlastní síť a Docker nám dovoluje jí docela lehce ovládat. Dovolí nám snadno vystrčit porty na hosta (čili webová aplikace v kontejneru vám chodí na localhostu), dovolí nám umístit některé kontejnery do stejné sítě.

Pozor na rozdíl mezi obraz (image) a container. Container je instancí obrazu.
Obdobný vztah jako soubor (binárka) vs proces.

Docker image má vrstvy. Ty jsou read-only. Díky tomu stahuje vrsty právě jednou. Např. když stáhnete dva kontejnery založené na fedoře, tak základní kontejner Fedory (resp. i jeho vrstvy) se stáhne jen jednou.

Běžící kontejner má volumes. To jsou speciální složky (popř. partitions) v hostu u kterých se počítá, že se do nich zapisuje a že je budeme chtít mít persistentní (zůstanou i po smazání kontejneru).

**Persistentní uložiště** (volume): namountované složky, které jsou persistentní mezi běhy. Mohou být:
 * nepojmenované: vytvoří se složka ve `/var/lib/docker/volumes/`, ale bude pojmenavaná hashem. Pozor vytváří se pro každý volumes v kontejneru - i pro takový s kterým v parametrech vůbec nepracujeme. Je dobré je občas promazat.
 * **pojmenovaný**: vytvoří se pojmenovaná složka ve `/var/lib/docker/volumes/`
 * mountovaný: využije se konkrétně zadaná složka v hostovi. Tato metoda není rozumná, protože narazíme na problémy s SElinuxem apod. Navíc je méně přehledná pro zorientování se a migraci.

QuickStart
----------

1. **Obrazy**. Stažení: `docker pull <user>/<image>:<version>`, vylistování: `docker images`, smazání: `docker rmi <image>`. Image můžeme nazývat jeho hashem (ten má vždy), nebo jménem: `<user>/<image>:<version>`
2. **Síť**: subcommand `network` s příkazy: `create`, `inspect`, `ls`, `rm`...
	- při spuštění definujeme kontejneru net-alias a ta se následně propíše do DNS v kontejneru. Čili spustíme container s `--net-alias mariadb` a v dalším containeru definujeme `--env="DB_HOST=mariadb"`
3. **Volumes**: subcomand `volume` s příkazy: `create`, `inspect`, `ls`, `rm`. Vytvoření: `docker volume create --name <name>`
4. **Běh**:
	- Jednorázově: `docker run -rm -it <params> <img>`, nakonci ještě může být příkaz, který chceme sputit. Typicky třeba `bash`
	- Jako démon: `docker run -d --name <name> --restart always <img>`
5. **Parametry**: Nejdůležitější parametry příkazu `run`:
	- porty: `-p <host>:<con>`, např.: `-p 1080:80`
	- volumes: `-v <name>:</path/in/con/>`, kde `<name>` je jmeno pojmenovaného volume.
	- `--volumes-from <con>`
	- `--net rednet --net-alias redmine`
  -`--restart [always|no|on-failure[:max-retries]]`
6. **Monitorování**:
	- `docker ps` vypíše běžící containery, parametr `-a` pro všechny
	- `docker logs <name>` zobrazí hlavní log containeru (typicky syslog)
	- `docker inspect <name>` vypíše všechny parametry
	- `docker stats [<container>]` využití prostředků

## Networking

Lze vytvářet přímo sítě v kterých je několik docker kontejnerů:

```
docker network create my-net
docker run --net my-net --net-alias mysql -e MYSQL_ROOT_PASSWORD=pw mariadb:10.1
docker run --net my net --net-alias wp -p 8080:80 -e WORDPRESS_DB_PASSWORD=pw  wordpress:4.6
```

## Údržba

Pokud s dockerem více experimentujete, tak se vám začnou hromadit obrazy i containery. Čili je občas potřeba zkontrolovat:

```bash
docker image        # stažené obrazy
docker volume ls    # volumes
docker network ls   # sítě
# A vše vyřeší:
docker system prune
```

## Konkrétní tipy

### DB

**Přístup do DB**: `docker run -it --rm mariadb:latest mysql -h<ip> -ur<user>-p<passwd> <db>`

**Run local DB**:

```
docker run -d --name my-db \
   --net netname --net-alias mariadb
   -v "my-db:/var/lib/mysql" mariadb` \
   -e MYSQL_ROOT_PASSWORD=<passwd> \
   -e MYSQL_DATABASE=<dbname> -e MYSQL_USER=<user> -e MYSQL_PASSWORD=<passwd> \
   mariadb:latest
```

Důležité je definovat síť a alias v dané síti, abychom se k DB mohli připojit z dalších containerů. Dále je dobré nastavit samostatný pojmenovaný volume, aby data byla persitentní.

**DB dump**:
```
docker exec <my-db> \
  sh -c 'exec mysqldump --all-databases -uroot -p"$MYSQL_ROOT_PASSWORD"' > /some/path/on/your/host/all-databases.sql
```


### Volumes

Připojení redmine-data (read-only) a aktuální složky.

```
sudo docker run --rm -ti -v "redmine-data:/redmine-data:ro" -v "$PWD:/pwd" alpine
```

V základním alpine máme ls, cp, tar, gz apod. Mohl by nám chybět rsync, popř. ssh. Buďto je můžeme doinstalovat:

```
apk update
apk add rsync openssh
```

Anebo použít přímo připravený obraz: `netroby/alpine-rsync` 

Popř. můžeme namountovat všechny volumes z běžícího kontejneru:

```
sudo docker run --rm -ti --volumes-from redmine:ro -v "$PWD:/pwd" alpine
```

### Aplikace

**Redmine**:
```
docker network create rednet
docker volume create --name redmine-db
docker volume create --name redmine-data
docker volume create --name redmine-logs
docker pull mariadb:latest
docker pull sameersbn/redmine:3.3.2-1
docker run -d --name redmine-db \
	--net rednet --net-alias mariadb
	-v "redmine-db:/var/lib/mysql" mariadb` \
	-e MYSQL_DATABASE=redmine -e MYSQL_USER=redmine -e MYSQL_PASSWORD=redmine \
	mariadb:latest
# Je třeba počkat než DB nahraje
docker run -d --name redmine \
	--net rednet --net-alias redmine \
	-v "redmine-data:/home/redmine/data " \
	-v "redmine-logs:/var/log/redmine" \
	-p 3000:80 --env='REDMINE_PORT=3000' \
	--env='DB_TYPE=mysql' --env='DB_ADAPTER=mysql2' \
	--env="DB_HOST=mariadb" --env='DB_NAME=redmine' --env='DB_USER=redmine' --env='DB_PASS=redmine' \
 	sameersbn/redmine:3.3.2-1
```

Může to znít složitě, ale díky tomu máme data uložna ve 3 izolovaných volumes, vše je zabaleno do jedné sítě z které jde ven jen jeden port a jsme schopni velmi nenáročně aktualizovat DB i aplikaci. Navíc se velmi podobně bude řešit jakákoliv jiná alikace.

