#!/bin/sh

if [ ! -f "/var/www/html/index.html" ]; then
    # debug
    mv /tmp/info.php /var/www/html/info.php

    mv /tmp/index.html /var/www/html/index.html

    # setting wordpress
    # https://qiita.com/IK12_info/items/4a9190119be2a0f347a0
    wp core download --allow-root
    while ! wp core config --dbname=$WP_DB_NAME --dbuser=$WP_DB_USER --dbpass=$WP_DB_PASSWORD --dbhost=$MYSQL_HOST --allow-root
    do
        echo "mariadb is in preparation"
        sleep 3
    done
    wp core install --url=${WP_URL} --title=Inception --admin_user=$WP_ADMIN_USER --admin_password=$WP_ADMIN_PASSWORD --admin_email=$WP_ADMIN_EMAIL --allow-root
    wp user create $WP_USER $WP_EMAIL --role=author --user_pass=$WP_PASSWORD --allow-root
fi

# -F: --nodaemonize
# -R: --allow-to-run-as-root
php-fpm8 -F -R
