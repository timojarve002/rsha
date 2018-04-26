#!/bin/bash

# lihtne kasutaja lisamise skript

if [ $# -ne 1 ]; then
	echo "Kasutusjuhend: Käsk kasutajanimi"
else
	# defineerime vajalik muutuja kasutajanimi salvestamiseks
	# kasutajanimi on esimene parameeter
	kasutajanimi=$1
	# kasutame kasutaja lisamise käsk vajalikute võtmetega
	useradd $kasutajanimi -m -s /bin/bash
  	# kontrollime
  	# $? - viimase! käsu väljund staatus, 0 kui on korras, muu kui on probleem
	if [ $? -eq 0 ]; then
    		echo "Kasutaja nimega $kasutajanimi on lisatud süsteemi"
		cat /etc/passwd | grep $kasutajanimi
		ls -la /home/$kasutajanimi
 	 else
		echo "probleem kasutaja $kasutajanimi lisamisega"
		echo "probleemi kood on $?"
	fi
	# kontrolli lõpp
fi
