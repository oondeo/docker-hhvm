FROM debian:jessie

MAINTAINER "Juan Ramon Alfaro" <info@oondeo.es>

RUN apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0x5a16e7281be7a449
RUN echo deb http://dl.hhvm.com/debian jessie-lts-3.12 main | tee /etc/apt/sources.list.d/hhvm.list

RUN apt-get clean && \
    apt-get update && \
    apt-get install -y libgmp10 hhvm && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install php tools (composer / phpunit)
RUN cd $HOME && \
    wget http://getcomposer.org/composer.phar && \
    chmod +x composer.phar && \
    mv composer.phar /usr/local/bin/composer && \
    wget https://phar.phpunit.de/phpunit.phar && \
    chmod +x phpunit.phar && \
    mv phpunit.phar /usr/local/bin/phpunit

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

