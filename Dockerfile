FROM krlmlr/debian-ssh:jessie

MAINTAINER André Cianfarani <a.cianfarani@c2is.fr>

RUN apt-get update && apt-get install -y vim apache2 php5-fpm php5-mysql php5-curl php5-gd php5-intl php5-mcrypt php5-xmlrpc
RUN a2enmod rewrite
RUN a2enmod proxy
RUN a2enmod proxy_fcgi
RUN mkdir /var/www/website

RUN cd /var/www/; php -r "readfile('https://getcomposer.org/installer');" > composer-setup.php
RUN cd /var/www/; php -r "if (hash('SHA384', file_get_contents('composer-setup.php')) === '41e71d86b40f28e771d4bb662b997f79625196afcca95a5abf44391188c695c6c1456e16154c75a211d238cc3bc5cb47') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"

RUN cd /var/www/; php composer-setup.php
RUN cd /var/www/; php -r "unlink('composer-setup.php');"

RUN ln -s /etc/apache2/sites-available/vhost-website.conf /etc/apache2/sites-enabled/vhost-website.conf

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

CMD ["/run.sh"]

EXPOSE 80