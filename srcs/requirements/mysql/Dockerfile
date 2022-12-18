FROM alpine:3.16

RUN apk update && apk upgrade && apk add --no-cache \
    mariadb \
    mariadb-client

COPY conf/mariadb-server.cnf /tmp/mariadb-server.cnf
COPY tools/setting.sh /tmp/setting.sh

ENTRYPOINT ["sh", "/tmp/setting.sh"]
