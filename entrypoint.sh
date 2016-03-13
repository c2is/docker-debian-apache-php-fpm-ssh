#!/bin/bash
set -e


if [ -z "$WEBSITE_HOST" ]; then
  WEBSITE_HOST="website.docker"
fi
if [ -z "$VHOST_DIRNAME" ]; then
  VHOST_DIRNAME="website"
else
  mkdir /var/www/$VHOST_DIRNAME
fi
if [ "$SYMFONY_VHOST_COMPLIANT" == "yes" ]; then
  SUFFIX="/web"
fi

if [ "$CAPISTRANO_VHOST_COMPLIANT" == "yes" ]; then
  mkdir /var/www/$VHOST_DIRNAME/releases
  mkdir /var/www/$VHOST_DIRNAME/shared
  chown -R www-data:www-data /var/www/$VHOST_DIRNAME
  PREFIX="/current"

fi
cat <<EOF >> /etc/apache2/sites-available/vhost-website.conf
<VirtualHost *:80>
        ServerName $WEBSITE_HOST
        ServerAlias *.$WEBSITE_HOST
        ServerAdmin webmaster@localhost
        DocumentRoot /var/www/$VHOST_DIRNAME$PREFIX$SUFFIX

        ErrorLog ${APACHE_LOG_DIR}/error.log
        CustomLog ${APACHE_LOG_DIR}/access.log combined

        <Directory /var/www/$VHOST_DIRNAME$SUFFIX>
          Order allow,deny
          Allow from all
          Require all granted
          Options -Indexes +FollowSymLinks -MultiViews
        </Directory>

        ProxyPassMatch ^/(.*\.php(/.*)?)$ fcgi://127.0.0.1:9000/var/www/$VHOST_DIRNAME$PREFIX$SUFFIX/\$1
</VirtualHost>
EOF

rm /etc/php5/fpm/pool.d/www.conf

cat <<EOF >> /etc/php5/fpm/pool.d/website.conf
[website]
user = www-data
group = www-data
listen = 127.0.0.1:9000
listen.owner = www-data
listen.group = www-data

pm = dynamic
pm.max_children = 5
pm.start_servers = 2
pm.min_spare_servers = 1
pm.max_spare_servers = 3
chdir = /
EOF

/etc/init.d/apache2 start
/etc/init.d/php5-fpm start

exec "$@"