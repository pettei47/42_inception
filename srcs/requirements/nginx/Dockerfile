FROM alpine:3.16

RUN apk update && apk upgrade && apk add --no-cache \
    nginx \
    openssl

# SSL configuration
# https://ozuma.hatenablog.jp/entry/20130511/1368284304
RUN mkdir /etc/nginx/ssl && \
    cd /etc/nginx/ssl && \
    openssl genrsa -out server.key && \
    openssl req -new -key server.key -out server.csr -subj '/C=JP/ST=Tokyo/L=Tokyo/O=tkitagaw/OU=Web/CN=localhost' && \
    openssl x509 -in server.csr -days 3650 -req -signkey server.key > server.crt

COPY conf/nginx.conf /etc/nginx/http.d/default.conf

# daemon off: https://heartbeats.jp/hbblog/2014/07/3-tips-for-nginx-on-docker.html
# -g: https://www.nginx.com/resources/wiki/start/topics/tutorials/commandline/
# global directives: https://blog.hashihei.com/2019/09/21/nginx-configration/
ENTRYPOINT ["nginx", "-g", "daemon off;"]
