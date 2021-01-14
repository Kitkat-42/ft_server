#!bin/bash

openssl req -newkey rsa:4096 -x509 -days 365 -nodes -subj "/C=KR/ST=GAEPO/L=Seoul/O=42Seoul/OU=Lee/CN=localhost" -keyout /etc/ssl/private/localhost.dev.key -out /etc/ssl/certs/localhost.dev.crt
chmod 600 etc/ssl/certs/localhost.dev.crt etc/ssl/private/localhost.dev.key

tar -xvf phpMyAdmin-5.0.2-all-languages.tar.gz
rm phpMyAdmin-5.0.2-all-languages.tar.gz
mv phpMyAdmin-5.0.2-all-languages /var/www/html/phpmyadmin
mv config.inc.php var/www/html/phpmyadmin/

service mysql start
mysql -u root --skip-password < var/www/html/phpmyadmin/sql/create_tables.sql
echo "CREATE DATABASE IF NOT EXISTS wordpress;" | mysql -u root --skip-password
echo "CREATE USER jinukim@localhost IDENTIFIED by '1234';" | mysql -u root --skip-password
echo "GRANT ALL PRIVILEGES ON *.* to jinukim@localhost;" | mysql -u root --skip-password

tar -xvf latest.tar.gz
rm latest.tar.gz
mv wordpress /var/www/html/
chown -R www-data:www-data /var/www/html/wordpress
mv wp-config.php /var/www/html/wordpress/

if [ "$AUTOINDEX" == "on" ]; then
	mv default_a ./etc/nginx/sites-available/default
else
	rm default_a
fi

service php7.3-fpm start
service nginx start
service mysql restart

bash
