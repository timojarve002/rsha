#!/bin/bash

#Lihtne kasutaja loomise skript


if [ $(id -u) -eq 0 ]; then
	#loeb kasutajanime
	read -p "Sisesta kasutajanimi: " nimi
	#kontrollib kas kasutaja on juba olemas
	if [ $? -eq 0 ]; then
		echo "$nimi kasutaja on juba olemas!"
		exit 1 
	#lisame kasutaja vastavalt sisendile
	else
		useradd -m $nimi -s /bin/bash
		[ $? -eq 0 ] && echo "Kasutaja on lisatud!" || echo "Probleem kasutaja lisamisega"

	fi
	#veateade kui pole piisavalt õigusi
else
	echo "Kas oled root kasutaja?"
	exit 1
fi
