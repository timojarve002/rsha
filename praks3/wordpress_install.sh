#!/bin/bash
#Wordpress install skript
if [ -d "/var/www/html/wordpress" ]; then
echo "Wordpress kaust on juba olemas"
exit
fi

#vajalike pakettide kontrollimine apache2, mysql, phpmyadmin
teenus=$(dpkg-query -W -f='${Status}' apache2 2>/dev/null | grep -c "ok installed")
teenus2=$(dpkg-query -W -f='${Status}' mysql-server 2>/dev/null | grep -c "ok installed")
teenus3=$(dpkg-query -W -f='${Status}' phpmyadmin 2>/dev/null | grep -c "ok installed")
teenus4=$(dpkg-query -W -f='${Status}' unzip 2>/dev/null | grep -c "ok installed")
#kui on paigaldatud siis tuleb grep loetud tulemusena 1 
#kui ei ole paigaldatud siis väljastab 0

#teenuse kontroll ja paigaldamine
if [ $teenus -eq 0 ]; then
	echo "Paigaldame enne apache"
	./apache_install.sh
else
	echo "Apache2 OK"
fi

#teenuse kontroll ja paigaldamine
if [ $teenus2 -eq 0 ]; then
	echo "Paigaldame enne mysql serveri"
	./mysql-server_install.sh
else
	echo "MySQL Server OK"
fi
if [ $teenus3 -eq 0 ]; then
	echo "Paigaldame enne phpmyadmin"
	./phpmyadmin_install
else
	echo "PHPMyadmin OK"
fi
if [ $teenus4 -eq 0 ]; then
	echo "Paigaldame enne unzip"
	apt-get install -y unzip
else
	echo "unzip OK"
fi
echo "------------------------------"
echo "WordPress Install start"
echo "------------------------------"
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
service apache2 restart
echo "------------------------------"
echo "Wordpress on installitud"
echo "------------------------------"

