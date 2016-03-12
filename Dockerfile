FROM krlmlr/debian-ssh:jessie

MAINTAINER André Cianfarani <a.cianfarani@c2is.fr>

RUN apt-get update && apt-get install -y vim apache2 php5-fpm php5-mysql php5-curl php5-gd php5-intl php5-mcrypt php5-xmlrpc
RUN a2enmod rewrite
RUN a2enmod proxy
RUN a2enmod proxy_fcgi
RUN mkdir /var/www/website

RUN ln -s /etc/apache2/sites-available/vhost-website.conf /etc/apache2/sites-enabled/vhost-website.conf

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

CMD ["/run.sh"]

EXPOSE 80