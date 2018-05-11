#!/bin/bash
#LEMP+wordpress install skript 
#apt-get update
#apt-get upgrade

#vajalike pakettide kontrollimine nginx, mysql, phpmyadmin
teenus=$(dpkg-query -W -f='${Status}' nginx 2>/dev/null | grep -c "ok installed")
teenus2=$(dpkg-query -W -f='${Status}' mysql-server 2>/dev/null | grep -c "ok installed")
teenus3=$(dpkg-query -W -f='${Status}' php5 2>/dev/null | grep -c "ok installed")
teenus4=$(dpkg-query -W -f='${Status}' phpmyadmin 2>/dev/null | grep -c "ok installed")
teenus5=$(dpkg-query -W -f='${Status}' unzip 2>/dev/null | grep -c "ok installed")
#kui on paigaldatud siis tuleb grep loetud tulemusena 1 
#kui ei ole paigaldatud siis väljastab 0

#nginx teenuse kontroll ja paigaldamine
if [ $teenus -eq 0 ]; then
	echo "Paigaldame nginx"
	apt-get install -y nginx
	echo "Sisestage oma serveri IP"
	read -e serverIP
	rida1=$(echo "server_name ""$serverIP""; ")
        sed -i "s@server_name _;@$rida1@" /etc/nginx/sites-available/default

	#nginx -t
else
	echo "nginx OK"
fi

#MySQL teenuse kontroll ja paigaldamine
if [ $teenus2 -eq 0 ]; then
	echo "------------------------------"
	echo "MySQL serveri paigaldus"
	echo "------------------------------"
	#./mysql-server_install.sh
	
	echo "MySQL root kasutaja parool:"
	read -s dbadminpw
	debconf-set-selections <<< 'mysql-server mysql-server/root_password password $dbadminpw'
	debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password $dbadminpw'
	apt-get -y install mysql-server	
	echo "MySQL server on paigaldatud!"
	
else
	echo "MySQL Server OK"
fi

#php5 teenuse kontroll ja paigaldamine
if [ $teenus3 -eq 0 ]; then
	echo "Paigaldame php5"
	apt-get install -y php5 php5-fpm php5-mysql php5-mcrypt php5-gd libssh2-php
	#vajalik default conf muuta
	#/etc/nginx/sites-available/default
	rida1=$(echo "        #       # With php5-fpm:")
	rida2=$(echo "	location ~ \.php$ { include snippets/fastcgi-php.conf;	fastcgi_pass unix:/var/run/php5-fpm.sock; }")

	sed -i "s!$rida1!&\n$rida2!" /etc/nginx/sites-available/default

	rida3=$(echo "index index.html index.htm index.nginx-debian.html;")
	rida4=$(echo "index index.php index.html index.htm index.nginx-debian.html; ")
	sed -i "s@$rida3@$rida4@" /etc/nginx/sites-available/default

	nginx -t
	echo "php5 ja moodulid paigaldatud"
else
	echo "php5 OK"
fi

#phpmyadmin paigaldus
if [ $teenus4 -eq 0 ]; then
	echo "Paigaldame phpmyadmin"
	php5enmod mcrypt

	#echo "PHPMyadmin kasutaja parool:"
	#read -s APP_PASS
	#echo "MySQL root parool:"
	#read -s ROOT_PASS
	#echo "PHPMyadmin andmebaasi parool:"
	#read -s APP_DB_PASS

	#parameetrite etteseadistamine phpmyadmin jaoks
	echo "phpmyadmin phpmyadmin/dbconfig-install boolean false" | debconf-set-selections
	#echo "phpmyadmin phpmyadmin/app-password-confirm password $APP_PASS" | debconf-set-selections
	#echo "phpmyadmin phpmyadmin/mysql/admin-pass password $ROOT_PASS" | debconf-set-selections
	#echo "phpmyadmin phpmyadmin/mysql/app-pass password $APP_DB_PASS" | debconf-set-selections
	echo "phpmyadmin phpmyadmin/reconfigure-webserver multiselect " | debconf-set-selections
	apt-get install -y phpmyadmin

	#phpmyadmin kausta linkimine nginx 
	ln -s /usr/share/phpmyadmin /usr/share/nginx/html
	service php5-fpm restart
	service nginx restart
else
	echo "PHPMyadmin OK"
fi

#vahepeatus
read -p "Kas soovite jätkata wordpressi installiga (y/n)? " answer
case ${answer:0:1} in
    y|Y )
        echo "Jätkame..."
    ;;
    * )
        exit
    ;;
esac

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
	mkdir -p wp-content/uploads
	chmod 755 wp-content/uploads
	cd ..

	mkdir /var/www/html/wordpress
	rsync -avP wordpress/ /var/www/html/wordpress/
	ln -s /var/www/html/wordpress /usr/share/nginx/html

echo "Ebavajalike failide eemaldamine"
#failide eemaldamine
rm -r wordpress/
rm latest.tar.gz

#mysql andmebaasi loomine
mysql -u$dbadmin -p$dbadminpw -e "create database $dbname; GRANT ALL PRIVILEGES ON $dbname.* TO $dbuser@localhost IDENTIFIED BY '$dbpass'; FLUSH PRIVILEGES"
service nginx restart
echo "------------------------------"
echo "Wordpress on installitud"
echo "------------------------------"
