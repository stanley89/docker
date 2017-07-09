FROM alpine:3.6
MAINTAINER Ondřej Profant

ADD script.sh entry.sh /usr/bin/
ADD crontab.txt /

RUN chmod 755 /usr/bin/script.sh /usr/bin/entry.sh
RUN /usr/bin/crontab /crontab.txt

CMD ["/usr/bin/entry.sh"]
