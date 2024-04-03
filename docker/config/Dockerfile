FROM php:8.3-fpm

ENV NODE_OPTIONS="--openssl-legacy-provider"
ENV NODE_MAJOR=20
ENV APCU_VERSION=5.1.23

RUN apt-get update && apt-get install -y gnupg
RUN mkdir -p /etc/apt/keyrings
RUN curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
RUN echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list

RUN apt-get update && apt-get install -y \
        git \
        unzip \
        libfreetype6-dev \
        zlib1g-dev \
        libjpeg62-turbo-dev \
        libicu-dev \
        libzip-dev \
        libxml2-dev \
        libpq-dev \
        libwebp-dev \
        nodejs \
        supervisor

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update && apt-get install -y yarn

RUN pecl install apcu-$APCU_VERSION && \
    docker-php-ext-install -j$(nproc) iconv zip exif \
    && docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-enable opcache \
    && docker-php-ext-configure intl \
    && docker-php-ext-install intl \
    && docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql \
    && docker-php-ext-install pgsql pdo_pgsql \
    && docker-php-ext-enable apcu

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN curl -sS https://getcomposer.org/installer | php && \
    mv composer.phar /usr/local/bin/composer && \
    curl -sS -L -o /usr/local/bin/phing https://www.phing.info/get/phing-2.17.4.phar && \
    chmod +x /usr/local/bin/phing

RUN curl -o /usr/local/bin/cachetool http://gordalina.github.io/cachetool/downloads/cachetool.phar

WORKDIR /var/www/

RUN pecl install xdebug && docker-php-ext-enable xdebug && \
    echo "xdebug.mode=debug" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini && \
    echo "xdebug.client_host=host.docker.internal" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini && \
    docker-php-source delete
