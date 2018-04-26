#!/bin/bash
#
# kasutajate lisamise skript failist paroolidega
if [ $# -ne 1 ]; then
	echo "Kasutusjuhend: $0 failinimi"
else
	failinimi=$1
	if [ -f $failinimi -a -r $failinimi ]; then
	echo "OK"
	for rida in $(cat $failinimi)
	do
	#faili sisu kättesaadav
		kasutajanimi=$(echo "$rida" | cut -f1 -d:)
		sh lisa_kasutaja.sh $kasutajanimi
		echo "$rida" | chpasswd #kasutajale vastav parool
	done
	else
		echo "probleem failiga $failinimi"
	fi
#kontrolli lõpp
fi
