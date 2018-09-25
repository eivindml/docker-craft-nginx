FROM zeit/wait-for:0.2 as wait

# Build dependencies
FROM composer:latest as vendor

COPY src/composer.json composer.json
COPY src/composer.lock composer.lock

RUN composer install --ignore-platform-reqs \
    --no-interaction --no-plugins --no-scripts \
    --prefer-dist --no-dev

FROM alpine:3.8

LABEL maintainer="Eivind Mikael Lindbråten <eivindml@icloud.com>"
LABEL description="Minimal Craft CMS Container using nginx."

# Copy over Craft files
COPY src/ /www/

# Copy over vendor files
COPY --from=vendor /app/vendor /www/vendor

# install nginx, php, and php extensions for Craft
RUN apk add --no-cache \
    bash \
    nginx \
    php7 \
    php7-fpm \
    php7-opcache \
    php7-phar \
    php7-zlib \
    php7-ctype \
    php7-session \
    php7-fileinfo \
# Required php extensions for Craft
    php7-pdo \
    php7-pdo_mysql \
    php7-gd \
    php7-openssl \
    php7-mbstring \
    php7-json \
    php7-curl \
    php7-zip \
# Optional extensions for Craft
    php7-iconv \
    php7-intl \
    php7-dom \
# Extra Optional extensions for Craft
    imagemagick \
    php7-imagick

COPY docker/php.ini /etc/php7/
COPY docker/nginx.conf /etc/nginx/
COPY docker/www.conf /etc/php7/php-fpm.d/

RUN chmod 777 -R /www/*

# Expose default port
EXPOSE 80

SHELL ["/bin/bash", "-c"]
COPY --from=wait /bin/wait-for /bin/wait-for

CMD php-fpm7 -F & (wait-for /tmp/php7-fpm.sock && nginx) & wait -n
