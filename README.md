## Description

- I don't use ready-made Docker images or DockerHub except for alpine
- The following three containers are connected in one network
  - nginx
  - wordpress
  - mariadb
- There are two volumes
  - Volume to store the page to be displayed
  - volume to store the database

## How to review

before start (verify any docker items running in your vm)
```
docker stop $(docker ps -qa); docker rm $(docker ps -qa); docker rmi -f $(docker images -qa); docker volume rm $(docker volume ls -q); docker network rm $(docker network ls -q) 2>/dev/null
```

Then, 
```
make
```

or

```
make d    //then, docker running on background
```

You have to input your user-password.  
(If you're in 42VM, it is `user42`.)

- Access to https://tkitagaw.42.fr  
  - (`http` is invalid)
  -  only port 443 is able to access.

- You can also access the wordpress login page at https://tkitagaw.42.fr/wp-login.php

### How to login mysql
```
make exec_mysql
```

```
mysql -u teppei -p
```
The password is written in `.env`.  

After you logined into mysql, you can check the data by below command.
```
use wordpress
show tables
```

```
select * from {any table you like} limit 5;
```

### How to stop

- press ctrl + c
  - If you built the docker by `make d`, this is not necessary.

```
make down
```

## Before finish review
- Due to clean your VM & reset /etc/hosts
```
make fclean
```
