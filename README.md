## How to review

```
make
```

or

```
make d    //then, docker running on background
```

Access to https://tkitagaw.42.fr  
(`http` is invalid)

You can also access the wordpress login page at  
https://tkitagaw.42.fr/wp-login.php

### How to stop

```
# press ctrl + c // If you built the docker by `make d`, this is not necessary.

make down
make fclean
```

## Description

- I don't use ready-made Docker images or DockerHub except for alpine
- The following three containers are connected in one network
  - nginx
  - wordpress
  - mariadb
- There are two volumes
  - Volume to store the page to be displayed
  - volume to store the database
