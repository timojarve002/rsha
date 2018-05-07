#!/bin/bash
#Wordpress install skript

echo "WordPress Install start"
echo "Sisestage andmebaasi nimi: "
read -e dbname
echo "Andmebaasi kasutaja: "
read -e dbuser
echo "Andmebaasi parool: "
read -s dbpass
echo "MySQL admin: "
read -e dbadmin
echo "MySQL parool:"
read -s dbadminpw

	#unzip paigaldus
	apt-get install -y unzip

echo "Wordpressi installitakse"
	#wordpressi allalaadimine
	wget http://wordpress.org/latest.tar.gz

	#unzip wordpress
	tar -zxvf latest.tar.gz
	#kaustavahetus
	cd wordpress
	#konfiguratsioonifaili loomine
	cp wp-config-sample.php wp-config.php
	#otsime ja asendame vajalikud võtmed
	perl -pi -e "s/database_name_here/$dbname/g" wp-config.php
	perl -pi -e "s/username_here/$dbuser/g" wp-config.php
	perl -pi -e "s/password_here/$dbpass/g" wp-config.php
	#
	cd ..
	mkdir /var/www/html/wordpress
	rsync -avP wordpress/ /var/www/html/wordpress/
echo "Ebavajalike failide eemaldamine"
#failide eemaldamine
rm -r wordpress/
rm latest.tar.gz
#mysql andmebaasi loomine
mysql -u$dbadmin -p$dbadminpw -e "create database $dbname; GRANT ALL PRIVILEGES ON $dbname.* TO $dbuser@localhost IDENTIFIED BY '$dbpass'; FLUSH PRIVILEGES"

echo "Wordpress on installitud"
service apache2 restart
