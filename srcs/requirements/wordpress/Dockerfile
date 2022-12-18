FROM alpine:3.16

# php extensions: https://qiita.com/0x50/items/3f6310f8cdf613a62b45
RUN apk update && apk upgrade && apk add --no-cache \
    mariadb-client \
    php8 \
    php8-fpm \
    php8-phar \
    php8-json \
    php8-mysqli \
    php8-mysqlnd \
    php8-curl \
    php8-dom \
    php8-exif \
    php8-fileinfo \
    php8-mbstring \
    php8-openssl \
    php8-xml \
    php8-zip

# setting php
# -S: system user: https://tech.withsin.net/2015/07/21/groupadd-useradd-r/
RUN	adduser -S nginx &&	addgroup -S nginx
# COPY conf/php-fpm.conf /etc/php8/php-fpm.conf
COPY conf/www.conf /etc/php8/php-fpm.d/www.conf

# download wp-cli: https://qiita.com/IK12_info/items/4a9190119be2a0f347a0
RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/bin/wp

# debug
COPY conf/info.php /tmp/info.php

COPY conf/index.html /tmp/index.html
COPY tools/setting.sh /tmp/setting.sh

# for read permission
RUN chmod 777 /tmp/info.php && \
    chmod 777 /tmp/index.html

WORKDIR /var/www/html/wordpress
ENTRYPOINT [ "sh", "/tmp/setting.sh" ]
