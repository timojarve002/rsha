#!/bin/bash
#
#
if [ $# -ne 1 ]; then
        echo "Kasutusjuhend: $0 kasutajanimi"
	exit
else

ipaddr=$(ifconfig | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p')
kasutajanimi=$1

a2enmod userdir
service apache2 reload

mkdir /home/$kasutajanimi/public
chmod -R 751 /home/$kasutajanimi/public
fi


