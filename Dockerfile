# Dockerfile
FROM php:8.3-apache

# Apache config
COPY conf/vhost.conf /etc/apache2/sites-available/000-default.conf
COPY conf/apache.conf /etc/apache2/conf-available/z-ambient.conf
COPY errors /errors
RUN a2enconf z-ambient

# Php config
RUN apt-get update -qq && \
    apt-get install -qy \
    git \
    gnupg \
    unzip \
    zip \
    nano 
RUN docker-php-ext-install -j$(nproc) opcache mbstring 
COPY conf/php.ini /usr/local/etc/php/conf.d/app.ini
