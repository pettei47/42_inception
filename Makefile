include srcs/.env

NEW_HOSTS			=	./new_hosts
ORIGIN_HOSTS	=	./origin_hosts


all: host volume
	cd srcs && docker-compose up --build

d: host volume
	cd srcs && docker-compose up --build -d

${ORIGIN_HOSTS}:
	cp /etc/hosts ${ORIGIN_HOSTS}

${NEW_HOSTS}:
	sudo sed -e 's/127.0.0.1/127.0.0.1	${WP_URL}/' /etc/hosts > ${NEW_HOSTS}	
	sudo cp ${NEW_HOSTS} /etc/hosts

host: ${ORIGIN_HOSTS} ${NEW_HOSTS}

${VOLUME_DIR}/${VOLUME_WEBSITE}:
	sudo mkdir -p ${VOLUME_DIR}/${VOLUME_WEBSITE}

${VOLUME_DIR}/${VOLUME_DB}:
	sudo mkdir -p ${VOLUME_DIR}/${VOLUME_DB}

volume: ${VOLUME_DIR}/${VOLUME_WEBSITE} ${VOLUME_DIR}/${VOLUME_DB}

down:
	cd srcs && docker-compose down

start:
	cd srcs && docker-compose start

stop:
	docker stop $(docker ps -qa)

cclean:
	docker rm $(docker ps -qa)

iclean:
	docker rmi $(docker images -qa)

vclean:
	sudo rm -rf ${VOLUME_DIR}/${VOLUME_WEBSITE} ${VOLUME_DIR}/${VOLUME_DB}
	docker volume rm $$(docker volume ls -q)

hclean: ${ORIGIN_HOSTS} ${NEW_HOSTS}
	sudo cp ${ORIGIN_HOSTS} /etc/hosts
	rm ${ORIGIN_HOSTS} ${NEW_HOSTS}

clean: down
	docker system prune -f

fclean: hclean clean vclean 

re: clean all

re_d: clean d

iclean_mysql: down stop
	docker rmi $(docker images mariadb -q)

iclean_wp: down stop
	docker rmi $(docker images wordpress -q)

iclean_nginx: down stop
	docker rmi $(docker images nginx -q)

exec_mysql:
	cd srcs && docker-compose exec mariadb /bin/ash

exec_wp:
	cd srcs && docker-compose exec wordpress /bin/ash

exec_nginx:
	cd srcs && docker-compose exec nginx /bin/ash

.PHONY: all d host volume down stop start \
				vclean iclean hclean clean fclean re re_d \
				iclean_mysql iclean_wp iclean_nginx \
				exec_mysql exec_wordpress exec_nginx