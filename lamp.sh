#!/bin/bash

echo "###################################################################################"
echo "Installation will start now.......and it will take some time :)"
echo "###################################################################################"

apt-get update
apt-get -y install apache2 php7.0 libapache2-mod-php7.0 php7.0-mcrypt php7.0-curl php7.0-mysql php7.0-gd php7.0-cli php7.0-dev mysql-client php-cli php7.0-gd php7.0-zip unzip
phpenmod mcrypt
export DEBIAN_FRONTEND="noninteractive"
MYSQL_PASS="StM0de@1"
echo "mysql-server mysql-server/root_password password $MYSQL_PASS" | sudo debconf-set-selections
echo "mysql-server mysql-server/root_password_again password $MYSQL_PASS" | sudo debconf-set-selections
apt-get install -y mariadb-server python-mysqldb

echo "<?php phpinfo();?>" >> /var/www/html/info.php
echo -e "\n"

service apache2 restart && service mysql restart > /dev/null

echo -e "\n"

if [ $? -ne 0 ]; then
   echo "Please Check the Install Services, There is some $(tput bold)$(tput setaf 1)Problem$(tput sgr0)"
else
   echo "Installed Services run $(tput bold)$(tput setaf 2)Sucessfully$(tput sgr0)"
fi

echo -e "\n"

MYSQL_PASS="StM0de@1"
MYSQL_USER="root"
MYSQL_DB="testing"



echo "phpmyadmin phpmyadmin/app-password-confirm password $MYSQL_PASS" | sudo debconf-set-selections
echo "phpmyadmin phpmyadmin/mysql/admin-pass password $MYSQL_PASS" | sudo debconf-set-selections
echo "phpmyadmin phpmyadmin/mysql/app-pass password $MYSQL_PASS"  | sudo debconf-set-selections
echo "phpmyadmin phpmyadmin/reconfigure-webserver multiselect none"  | sudo debconf-set-selections
echo "phpmyadmin phpmyadmin/dbconfig-install boolean true"  | sudo debconf-set-selections

apt-get install -y phpmyadmin

mysql -uroot -p$MYSQL_PASS -e "CREATE DATABASE $MYSQL_DB"
mysql -uroot -p$MYSQL_PASS -e "grant all privileges on $MYSQL_DB.* to '$MYSQL_USER'@'localhost' identified by '$MYSQL_PASS'"

service apache2 restart
