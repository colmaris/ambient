# Utiliser une image de base officielle de PHP avec FPM (FastCGI Process Manager)
FROM php:8.1-fpm

# Installer les dépendances nécessaires pour PHP
RUN apt-get update && apt-get install -y \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    libzip-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-install zip

# Copier le code source de l'application PHP dans le conteneur
COPY ./src /var/www/html

# Définir le répertoire de travail
WORKDIR /var/www/html

# Exposer le port 9000 pour PHP-FPM
EXPOSE 9000
