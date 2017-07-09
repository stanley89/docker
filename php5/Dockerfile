FROM alpine:3.6

MAINTAINER Ondrej Profant

# For PHP modules see PHP7
RUN apk add --no-cache php5 

COPY hello.php5 /src/

CMD ["php5", "/src/hello.php5"]
