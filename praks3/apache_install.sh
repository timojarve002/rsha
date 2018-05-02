#!/bin/bash
# apache install skript

#kontrollime kas apache2 on paigaldatud
teenus=$(dpkg-query -W -f='${Status}' apache2 2>/dev/null | grep -c "ok installed")
#kui on paigaldatud siis tuleb grep loetud tulemusena 1 
#kui ei ole paigaldatud siis väljastab 0

#teenuse paigaldamine
if [ $teenus -eq 0 ]; then
	echo "Paigaldame apache2"
	apt-get install -y apache2;
elif [ $teenus -eq 1 ]; then
	echo "Apache2 on juba paigaldatud"
 	#teenuse staatuse näitamine
	service apache2 status
fi
