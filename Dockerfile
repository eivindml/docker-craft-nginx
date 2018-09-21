FROM zeit/wait-for:0.2 as wait

# Build dependencies
FROM composer:latest as vendor

COPY composer.json composer.json
COPY composer.lock composer.lock

RUN composer install --ignore-platform-reqs --no-interaction --no-plugins --no-scripts --prefer-dist --no-dev

FROM alpine:3.8

LABEL maintainer="Eivind Mikael Lindbråten <eivindml@icloud.com>"
LABEL description="Minimal Craft CMS Container using nginx."

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
    php7-dom

COPY nginx.conf /etc/nginx/nginx.conf
COPY www.conf /etc/php7/php-fpm.d/

# Copy over Craft files
COPY config/ /www/config
COPY modules/ /www/modules
COPY storage/ /www/storage
COPY templates/ /www/templates
COPY storage/ /www/storage
COPY web/ /www/web
COPY .env /www/.env
COPY composer.json /www/composer.json
COPY composer.lock /www/composer.lock

# Copy over vendor files
COPY --from=vendor /app/vendor /www/vendor

# Set permissions
RUN chmod 777 -R /www/config
RUN chmod 777 -R /www/vendor
RUN chmod 777 -R /www/storage
RUN chmod 777 -R /www/web/cpresources
RUN chmod 777 /www/.env
RUN chmod 777 /www/composer.json
RUN chmod 777 /www/composer.lock

# Expose default port
EXPOSE 80

SHELL ["/bin/bash", "-c"]
COPY --from=wait /bin/wait-for /bin/wait-for

CMD php-fpm7 -F & (wait-for /tmp/php7-fpm.sock && nginx) & wait -n
