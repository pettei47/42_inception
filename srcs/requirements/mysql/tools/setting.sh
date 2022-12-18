#!/bin/sh

# handling Error `socket file don't exists`
# https://qiita.com/naberina/items/5dcf178fc3ca02c61b05
mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld

if [ ! -d "/var/lib/mysql/mysql" ]; then

    chown -R mysql:mysql /var/lib/mysql

    # database initialization
    # https://mariadb.com/kb/en/mysql_install_db/
    mysql_install_db --datadir=/var/lib/mysql --user=mysql

    # database settings
    # https://qiita.com/jh1vxw/items/aa4530e84049bd80a1c0
    # mysql, mysqld_safe, mysqld: https://monologu.com/mysqld-mysqld_safe-mysql-server-diff/
    # mysqld: http://www.limy.org/program/db/mysql/mysql_option.html
    # secure mysql: https://docs.bitnami.com/google/infrastructure/mysql/administration/secure-server-mysql/
    # 'localhost', '127.0.0.1', '::1': https://www.javadrive.jp/apache/install/index8.html
    # configuration for wordpress: https://program.sagasite.info/wiki/index.php?WordPress%E3%81%AE%E3%82%A4%E3%83%B3%E3%82%B9%E3%83%88%E3%83%BC%E3%83%AB
    /usr/bin/mysqld --user=mysql --bootstrap << EOF
USE mysql;
FLUSH PRIVILEGES;

DELETE FROM mysql.user WHERE User='';
DROP DATABASE test;
DELETE FROM mysql.db WHERE Db='test';
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');

ALTER USER 'root'@'localhost' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD';

CREATE DATABASE $WP_DB_NAME;
CREATE USER '$WP_DB_USER'@'%' IDENTIFIED by '$WP_DB_PASSWORD';
GRANT ALL PRIVILEGES ON $WP_DB_NAME.* TO '$WP_DB_USER'@'%';

FLUSH PRIVILEGES;
EOF
fi
# CREATE DATABASE $WP_DB_NAME CHARACTER SET utf8 COLLATE utf8_general_ci;

# overwrite configuration files
# allow remote operation: https://mariadb.com/kb/en/configuring-mariadb-for-remote-client-access/
cp /tmp/mariadb-server.cnf /etc/my.cnf.d/mariadb-server.cnf

exec /usr/bin/mysqld --user=mysql --console
