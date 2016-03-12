# C2is container for Debian Jessie Apache 2.4 And Php 5.6 (apache module)

### Usage 

##### Edit your /etc/hosts file and add the line:
```
127.0.0.1 projectname.loc
```
Host value could be changed according your choice below  
Warning for macosx and windows users : ip value should be changed according your Docker's VM ip

##### With docker-compose (use image already built from docker's hub)
```
# In your docker-compose.yml file
c2isapachefpm:
    image: c2is/debian-apache-php-fpm-ssh
    ports:
        - 80:80
    environment:
        # Default: website.docker
        WEBSITE_HOST: projectname.loc
        # Default: no, DocumentRoot have not the trailing /web/
        SYMFONY_VHOST_COMPLIANT: yes
        CAPISTRANO_VHOST_COMPLIANT: "yes"
        SSH_KEY:"$(cat ~/.ssh/id_rsa.pub)"
```

##### With docker directly
```
git clone git@github.com:c2is/docker-debian-apache-php-fpm-ssh.git
cd docker-debian-apache-php-fpm-ssh
docker build -t . c2isDebAp
docker run -d -e WEBSITE_HOST=projectname.loc -e SSH_KEY="$(cat ~/.ssh/id_rsa.pub)" -e SYMFONY_VHOST_COMPLIANT=yes -e CAPISTRANO_VHOST_COMPLIANT=yes c2isDebAp
```

##### Then crawl you application : http://website.docker/