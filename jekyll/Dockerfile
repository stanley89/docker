FROM alpine:latest
MAINTAINER Ondřej Profant

ENV repo=jekylltest.pirati.cz \
    force=false \
    tests=false

RUN apk add --no-cache git ruby ruby-dev ruby-bundler build-base libffi-dev zlib
RUN gem install --no-rdoc --no-ri bundler --pre 

VOLUME /mnt/repo /mnt/build

ADD entry.sh /usr/bin/

#RUN adduser -D -u 1000 jekyll

#RUN chown -R jekyll:jekyll /usr/bin/entry.sh /mnt/repo &&

RUN chmod 755 /usr/bin/entry.sh

# USER jekyll

CMD ["/usr/bin/entry.sh"]
