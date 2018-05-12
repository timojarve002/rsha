#!/bin/bash
# Andmebaasi varundamise skript
# Mõeldud root kasutaja õigustega kasutamiseks


#kontroll
if [ $# -ne 1 ]; then
        echo "Kasutusjuhend: $0 kasutajanimi "

        else
kasutajanimi=$1
datetime=$(date +"%Y-%m-%d.%H-%M")

#kasutaja olemasolu kontroll
if id "$1" >/dev/null 2>&1; then
       echo "Kasutaja OK"
else
        echo "Kasutajat ei eksisteeri"
	exit
fi

		if [ ! -d ~/mysql_backup ]; then
  		mkdir ~/mysql_backup;
		fi

		#Kui skriptis parooli loomist ei toimu tuleb lugeda parool conf failist
		parool=$(grep -A 100 'password' /home/$kasutajanimi/.my.cnf | cut -f2 -d '=')

	#otsime kasutaja andmebaase
	rida=$(echo "$kasutajanimi"%"")
	echo "Sisestage root parool: "
	read -s dbrootpw 
	
	mysql -uroot -p$dbrootpw --silent -e "SHOW DATABASES LIKE '$rida'" >> tempfail.tmp
	
        echo "Leitud andmebaasid: "
        cat tempfail.tmp

	db_host="localhost"
	db_port="3306"
	
	#vahepeatus
	read -p "Kas soovite need andmebaasid varundada (y/n)? " answer
	case ${answer:0:1} in
	y|Y )
        echo "Jätkame..."
	for db_name in $(cat tempfail.tmp)
		do
		
		mysqldump -uroot -h $db_host -P $db_port -p$dbrootpw $db_name | gzip -9 > ~/mysql_backup/$datetime.$db_name.backup.sql.gz
		
		#mysqldump -uroot -pdbrootpw $db_name | gzip -9 > ~/mysql_backup/$datetime.$db_name.backup.sql.gz
		
		echo "$db_name andmbaas on varundatud!"
		done

	echo "Kõik andmebaasid on varundatud"
	rm tempfail.tmp
    	;;
    	* )
	rm tempfail.tmp
        exit
    	;;
	esac
		
fi
