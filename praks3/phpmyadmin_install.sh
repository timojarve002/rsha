#!/bin/bash
# phpmyadmin install skript

#kontrollime kas phpmyadmin on paigaldatud
teenus=$(dpkg-query -W -f='${Status}' phpmyadmin 2>/dev/null | grep -c "ok installed")
#kui on paigaldatud siis tuleb grep loetud tulemusena 1 
#kui ei ole paigaldatud siis väljastab 0

#teenuse paigaldamine
if [ $teenus -eq 0 ]; then
	echo "Paigaldame phpmyadmin"
	#php lisamooduli paigaldamine
	apt-get install -y mcrypt
	service apache2 restart

	#paroolide seadistamine
	APP_PASS="qwerty"
	ROOT_PASS="qwerty"
	APP_DB_PASS="qwerty"

	#parameetrite etteseadistamine phpmyadmin jaoks
	echo "phpmyadmin phpmyadmin/dbconfig-install boolean true" | debconf-set-selections
	echo "phpmyadmin phpmyadmin/app-password-confirm password $APP_PASS" | debconf-set-selections
	echo "phpmyadmin phpmyadmin/mysql/admin-pass password $ROOT_PASS" | debconf-set-selections
	echo "phpmyadmin phpmyadmin/mysql/app-pass password $APP_DB_PASS" | debconf-set-selections
	echo "phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2" | debconf-set-selections
	#installime phpmyadmin paketi
	apt-get install -y phpmyadmin

elif [ $teenus -eq 1 ]; then
	echo "phpmyadmin  on paigaldatud"
fi
