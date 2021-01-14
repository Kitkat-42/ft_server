FROM debian:buster

RUN apt-get update
RUN apt-get -y upgrade
RUN apt-get -y install vim nginx openssl php-fpm mariadb-server php-mysql php-mbstring php-curl

COPY ./srcs/init.sh /
COPY ./srcs/default /etc/nginx/sites-available/
COPY ./srcs/default_a /
COPY ./srcs/config.inc.php /
COPY ./srcs/wp-config.php /
COPY ./srcs/phpMyAdmin-5.0.2-all-languages.tar.gz /
COPY ./srcs/latest.tar.gz /

CMD bash init.sh
