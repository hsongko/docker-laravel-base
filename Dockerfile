ARG ARCH=
FROM ${ARCH}php:7.4-fpm-alpine

MAINTAINER Heru Sasongko <sasongko.heru@gmail.com>

## --- ESSENTIAL ---
RUN set -eux; \
  apk add --no-cache \
    curl \
    nginx \
    nodejs \
    npm \
    supervisor \
    git \
    bash \
    tzdata; \
  \
  sed -i 's/bin\/ash/bin\/bash/g' /etc/passwd; \
  \
  ## --- install composer ---
  curl -sS https://getcomposer.org/installer -o composer-setup.php; \
  php composer-setup.php --install-dir=/usr/local/bin --filename=composer; \
  rm -rf composer-setup.php; \
  \
  ## --- fix permission /var/lib/nginx ---
  chown -R www-data:www-data /var/lib/nginx; \
  \
  ## --- set timezone Asia/Jakarta ---
  cp /usr/share/zoneinfo/Asia/Jakarta /etc/localtime; \
  apk del --no-cache tzdata;


## --- INSTALL PHP EXTENSION ---
ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/
RUN set -eux; \
  chmod +x /usr/local/bin/install-php-extensions; \
  sync; \
  install-php-extensions \
    exif \
    gd \
    intl \
    memcached \
    mongodb \
    opcache \
    pcntl \
    pdo_pgsql \
    pgsql \
    sockets \
    zip;

## --- Configure nginx ---
COPY ./docker/nginx/nginx.conf /etc/nginx/nginx.conf
COPY ./docker/nginx/default.conf /etc/nginx/conf.d/default.conf
RUN set -eux; \
   ln -sf /dev/stdout /var/log/nginx/access.log; \
   ln -sf /dev/stderr /var/log/nginx/error.log;
   
## --- Configure supervisor ---
RUN mkdir -p /etc/supervisor.d/;
COPY ./docker/supervisord/supervisord.ini /etc/supervisor.d/supervisord.ini

EXPOSE 80 443 9000

CMD ["supervisord", "-c", "/etc/supervisor.d/supervisord.ini"]