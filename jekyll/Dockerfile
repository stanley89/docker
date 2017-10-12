FROM debian:stretch
MAINTAINER Ondřej Profant

ENV repo=jekylltest.pirati.cz \
    force=false \
    tests=false

RUN apt-get update && apt-get install -y git ruby ruby-dev ruby-bundler libffi-dev build-essential zlib1g-dev webhook
#RUN gem install --no-rdoc --no-ri bundler --pre 

VOLUME /mnt/repo /mnt/build

ADD entry.sh /usr/bin/

ADD hooks.json /etc/

#RUN adduser -D -u 1000 jekyll

#RUN chown -R jekyll:jekyll /usr/bin/entry.sh /mnt/repo &&

RUN chmod 755 /usr/bin/entry.sh

# USER jekyll

CMD ["/usr/bin/webhook", "-verbose", "-hooks=/etc/hooks.json"]
