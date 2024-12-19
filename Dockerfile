FROM php:8.3-apache

EXPOSE 80
WORKDIR /app

HEALTHCHECK --interval=1m --timeout=3s --start-period=5s --start-interval=1s --retries=3 \
    CMD curl -f http://localhost/_health || exit 1

# git, unzip & zip are for composer
RUN apt-get update -qq && \
    apt-get install -qy \
    git \
    gnupg \
    unzip \
    zlib1g \
    zip && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /var/log/*

# PHP Extensions
RUN docker-php-ext-install -j$(nproc) bcmath
COPY --link conf/php.ini /usr/local/etc/php/conf.d/app.ini

# Apache
COPY --link errors /errors
COPY --link health.php /health/index.php
COPY --link conf/vhost.conf /etc/apache2/sites-available/000-default.conf
COPY --link conf/apache.conf /etc/apache2/conf-available/z-ambient.conf
COPY --link /src /app

RUN a2enmod rewrite remoteip && \
    a2enconf z-ambient
