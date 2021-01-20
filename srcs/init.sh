#!bin/bash
echo "AUTOINDEX [on/off]? "
read AUTOINDEX

# setup ssl
openssl req -newkey rsa:4096 -x509 -days 365 -nodes -subj "/C=KR/ST=GAEPO/L=Seoul/O=ECOLE42/OU=42SEOUL/CN=localhost" -keyout /etc/ssl/private/localhost.dev.key -out /etc/ssl/certs/localhost.dev.crt
chmod 600 etc/ssl/certs/localhost.dev.crt etc/ssl/private/localhost.dev.key

# install phpmyadmin
tar -xvf phpMyAdmin-5.0.2-all-languages.tar.gz
rm phpMyAdmin-5.0.2-all-languages.tar.gz
mv phpMyAdmin-5.0.2-all-languages /var/www/html/phpmyadmin
mv config.inc.php var/www/html/phpmyadmin/

# setup DB
service mysql start
mysql -u root --skip-password < var/www/html/phpmyadmin/sql/create_tables.sql
echo "CREATE DATABASE IF NOT EXISTS wordpress;" | mysql -u root --skip-password
echo "CREATE USER seojeong@localhost IDENTIFIED by 'seojeong';" | mysql -u root --skip-password
echo "GRANT ALL PRIVILEGES ON *.* to seojeong@localhost;" | mysql -u root --skip-password

# install wordpress
tar -xvf latest.tar.gz
rm latest.tar.gz
mv wordpress /var/www/html/
chown -R www-data:www-data /var/www/html/wordpress
mv wp-config.php /var/www/html/wordpress/

# autoindex on/off
if [ "$AUTOINDEX" == "on" ]; then
	mv default_a ./etc/nginx/sites-available/default
else
	rm default_a
fi

# start services
service php7.3-fpm start
service nginx start
service mysql restart

bash
