include srcs/.env

NEW_HOSTS			=	./hosts
ORIGIN_HOSTS	=	./origin_hosts


all: origin_hosts ${VOLUME_DIR}/${VOLUME_WEBSITE} ${VOLUME_DIR}/${VOLUME_DB}
	cd srcs && docker-compose up --build

d: origin_hosts ${VOLUME_DIR}/${VOLUME_WEBSITE} ${VOLUME_DIR}/${VOLUME_DB}
	cd srcs && docker-compose up --build -d

origin_hosts:
	sudo sed -e 's/127.0.0.1/127.0.0.1	${WP_URL}/' /etc/hosts > ${NEW_HOSTS}
	cp /etc/hosts ${ORIGIN_HOSTS}
	sudo cp ${NEW_HOSTS} /etc/hosts

${VOLUME_DIR}/${VOLUME_WEBSITE}:
	sudo mkdir -p ${VOLUME_DIR}/${VOLUME_WEBSITE}

${VOLUME_DIR}/${VOLUME_DB}:
	sudo mkdir -p ${VOLUME_DIR}/${VOLUME_DB}

down:
	cd srcs && docker-compose down

stop: down

vclean:
	sudo rm -rf ${VOLUME_DIR}/${VOLUME_WEBSITE} ${VOLUME_DIR}/${VOLUME_DB}
	docker volume rm $$(docker volume ls -q)

iclean:
	docker rmi $$(docker images -a -q)

hclean:
	sudo cp ${ORIGIN_HOSTS} /etc/hosts
	rm ${ORIGIN_HOSTS} ${NEW_HOSTS}

clean:
	docker system prune -f

fclean: clean volume_clean image_clean host_clean

re: fclean all

exec_mysql:
	cd srcs && docker-compose exec mariadb /bin/ash

exec_wordpress:
	cd srcs && docker-compose exec wordpress /bin/ash

exec_nginx:
	cd srcs && docker-compose exec nginx /bin/ash

.PHONY: all d down stop vclean iclean hclean clean fclean re exec_mysql exec_wordpress exec_nginx
