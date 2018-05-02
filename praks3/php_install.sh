#!/bin/bash
# php5 install skript

#kontrollime kas php5 on paigaldatud
teenus=$(dpkg-query -W -f='${Status}' php5 2>/dev/null | grep -c "ok installed")
#kui on paigaldatud siis tuleb grep loetud tulemusena 1 
#kui ei ole paigaldatud siis väljastab 0

#teenuse paigaldamine
if [ $teenus -eq 0 ]; then
	echo "Paigaldame php"
	apt-get install -y php5;
elif [ $teenus -eq 1 ]; then
	echo "php on juba paigaldatud"
 	#teenuse versiooni näitamine
	php -v
fi
