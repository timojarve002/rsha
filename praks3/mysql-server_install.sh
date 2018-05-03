#!/bin/bash
# apache install skript

#kontrollime kas apache2 on paigaldatud
teenus=$(dpkg-query -W -f='${Status}' mysql-server 2>/dev/null | grep -c "ok installed")
#kui on paigaldatud siis tuleb grep loetud tulemusena 1 
#kui ei ole paigaldatud siis väljastab 0

#teenuse paigaldamine
if [ $teenus -eq 0 ]; then
	echo "Paigaldame mysql-serveri"
	debconf-set-selections <<< 'mysql-server mysql-server/qwerty qwerty qwerty'
	debconf-set-selections <<< 'mysql-server mysql-server/qwerty qwerty qwerty'
	apt-get -y install mysql-server	

elif [ $teenus -eq 1 ]; then
	echo "mysql-server on paigaldatud"
 	#teenuse staatuse näitamine
	service mysql-server status
fi