FROM debian:jessie

MAINTAINER "Juan Ramon Alfaro" <info@oondeo.es>

RUN apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0x5a16e7281be7a449
RUN echo deb http://dl.hhvm.com/debian jessie main | tee /etc/apt/sources.list.d/hhvm.list

RUN apt-get clean && \
    apt-get update && \
    apt-get install -y libgmp10 hhvm && \
    rm -rf /var/lib/apt/lists/*

COPY php.ini /etc/hhvm/php.ini
COPY start.sh /start.sh

RUN mkdir -p /var/www /var/run/hhvm /var/lib/hhvm /var/log/hhvm && \
    chown -R www-data:www-data /var/www /var/run/hhvm /var/lib/hhvm /var/log/hhvm /etc/hhvm


VOLUME [ "/var/www","/var/lib/hhvm/sessions", "/etc/hhvm/php.ini" ]


USER www-data

ENV PORT 9000
ENV DEVELOPMENT "false"
ENV ROOT "/var/www"

EXPOSE $PORT

CMD ["/start.sh"]

