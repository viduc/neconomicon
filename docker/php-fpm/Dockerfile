########################################################################################################################
## NECONOMICON - https://github.com/viduc/neconomicon                                                                 ##
## This file is a part of NECONOMICON application                                                                     ##
########################################################################################################################
FROM php:8.3.6-fpm-bullseye

ARG ENABLE_XDEBUG=0
ARG XDEBUG_REMOTE_PORT=9000
ARG ENABLE_PCOV=0
# Parametres
ARG UID=1000
ARG GID=1000

# Environment variables
ENV APCU_VERSION=5.1.22 \
    COMPOSER_ALLOW_SUPERUSER=1

RUN apt-get update && apt-get install -y \
    acl \
    apt-transport-https \
    build-essential \
#    ca-certificates \
    dirmngr \
    g++ \
    gcc \
    git \
    libevent-dev \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libicu-dev \
    libmcrypt-dev \
    libpng-dev \
    libpq-dev \
    libssl-dev \
    libzip-dev \
    lsb-release \
    make \
    poppler-utils \
    unzip \
    wget \
    zip \
	&& docker-php-ext-configure gd --with-freetype --with-jpeg \
	&& docker-php-ext-install -j$(nproc) gd \
	&& docker-php-ext-install \
		bcmath \
		intl \
		pdo_pgsql \
		pgsql \
		sockets \
		zip

RUN docker-php-ext-configure ftp --with-openssl-dir=/usr \
	&& docker-php-ext-install ftp

# install nodejs
RUN curl -s https://deb.nodesource.com/setup_20.x | bash
RUN apt-get install -y nodejs

# install yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get install -y yarn

# allow ports<1024 to nodejs
RUN apt-get install -y libcap2-bin
RUN /sbin/setcap CAP_NET_BIND_SERVICE=+eip /usr/bin/node

# Docker extensions
ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/
RUN chmod +x /usr/local/bin/install-php-extensions

# PHP extensions
RUN install-php-extensions \
    #amqp \
    apcu-${APCU_VERSION} \
    event \
    opcache \
    #redis \
    xdebug \
    yaml

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer --version=2.4.1

ADD symfony.ini /usr/local/etc/php/conf.d/
ADD xdebug.ini /usr/local/etc/php/conf.d/
ADD symfony.pool.conf /usr/local/etc/php-fpm.d/

# PCOV
ADD pcov.ini /tmp/pcov.ini
RUN if [ "$ENABLE_PCOV" = "1" ]; \
	then install-php-extensions pcov; \
		mv /tmp/pcov.ini /usr/local/etc/php/conf.d/pcov.ini; \
	fi

# Adding user

RUN addgroup -gid=$GID neconomicon && \
    adduser -uid=$UID --home=/home/neconomicon --shell=/bin/bash --ingroup=neconomicon --disabled-password --quiet neconomicon
WORKDIR /var/www/symfony

CMD ["php-fpm"]
