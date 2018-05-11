#!/bin/bash
#skript mis võtab parameetrina kasutajanime ja loob antud nimega kasutajat andmebaasi serveris
#

kasutajanimi=$1

#kontroll kas on sisestatud kasutajanimi
if [ $# -ne 1 ]; then
        echo "Kasutusjuhend: $0 kasutajanimi "
else

#genereerime suvalise parooli
parool=$(tr -cd '[:alnum:]' < /dev/urandom | fold -w30 | head -n1)

#salvestame kasutaja nime ja parooli
echo "[client]" >> /home/$kasutajanimi/.my.cnf
echo "user=$kasutajanimi" >> /home/$kasutajanimi/.my.cnf
echo "password=$parool" >> /home/$kasutajanimi/.my.cnf

#määrame korrektsed õigused failile
chown "$kasutajanimi"":""$kasutajanimi" /home/$kasutajanimi/.my.cnf
chmod 644 /home/$kasutajanimi/.my.cnf

	echo "MySQL root parool:"
	read -s dbadminpw
	echo "Sisestage soovitud andmebaasi nimi:"
	read -e dbname
	dbname2=$(echo "$kasutajanimi""_""$dbname")

	mysql -uroot -p$dbadminpw -e "CREATE DATABASE $dbname2; GRANT ALL PRIVILEGES ON $dbname2.* TO $kasutajanimi@localhost IDENTIFIED BY '$parool'; FLUSH PRIVILEGES;"
	echo "---------------------------------------------------"
	echo "$kasutajanimi andmebaas $dbname2 on loodud!"
	echo "---------------------------------------------------"

fi
