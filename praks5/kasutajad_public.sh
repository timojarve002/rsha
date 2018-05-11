#!/bin/bash
# lihtne kasutaja veebikausta lisamise skript

if [ $# -ne 1 ]; then
	echo "Kasutusjuhend: $0 kasutajanimi"
else

#kasutaja olemasolu kontroll
if id "$1" >/dev/null 2>&1; then
        echo "Kasutaja OK"
else
        echo "Kasutajat ei eksisteeri"
	exit
fi
	# defineerime vajalik muutuja kasutajanimi salvestamiseks
	# kasutajanimi on esimene parameeter
	kasutajanimi=$1
	ipaddr=$(ifconfig | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p')
	
	#apache2 laienduse lubamine ning konfiguratsiooni muutmine vastavalt ül.
	a2enmod userdir
	sed -i 's/public_html/public/g' /etc/apache2/mods-available/userdir.conf
	
	#kasutaja veebikausta kontroll
	if [ -d "/home/$kasutajanimi/public" ]; then
	echo "$kasutajanimi veebikaust on juba olemas  $ipaddr"/~"$kasutajanimi"
	
	rights=$(stat -c %a /home/$kasutajanimi/public)
	if [ $rights -eq 751 ]; then
	echo "Kausta õigused OK"
	else
	chmod -R 751 /home/$kasutajanimi/public
	chown -R $kasutajanimi:www-data /home/$kasutajanimi/public
	echo "Kausta õigused on parandatud!"
	fi
	exit
	fi

	#kausta loomine ja õiguste määramine, test veebileht
	mkdir /home/$kasutajanimi/public
	chmod -R 751 /home/$kasutajanimi/public
	chown -R $kasutajanimi:www-data /home/$kasutajanimi/public
	echo "<html><body><h1>Tere $kasutajanimi oma veebilehele</h1></body></html>" > /home/$kasutajanimi/public/index.html
	service apache2 restart

  	# $? - viimase! käsu väljund staatus, 0 kui on korras, muu kui on probleem
	if [ $? -eq 0 ]; then

    		echo "Kasutaja $kasutajanimi veebikaust on lisatud $ipaddr"/~"$kasutajanimi"
 	 else
		echo "probleem kasutaja $kasutajanimi veebikausta lisamisega"
		echo "probleemi kood on $?"
	fi
	# kontrolli lõpp
fi

