FROM alpine:latest
MAINTAINER Ondrej Profant

RUN apk --update --no-cache add wget curl git openssl tzdata \
	php7 php7-curl php7-openssl php7-json php7-phar php7-dom php7-iconv php7-mbstring php7-zlib php7-gd;

COPY hello.php /src/

CMD ["php", "/src/hello.php"]
