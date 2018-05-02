
#!/bin/bash
# kasutajate lisamise skript kahest erinevast failist
# iga rida ühes failis vastab reale teises failis

#kontroll kas on sisestatud 2 faili
if [ $# -ne 2 ]; then
        echo "Kasutusjuhend: $0 fail1 fail2"
        echo "Fail1 kasutajad, fail2 paroolid"
else

        fail1=$1
        fail2=$2
	
	#failide kontroll ja ajutise faili loomine
        if [ -f $fail1 -a -r $fail1 ] && [ -f $fail2 -a -r $fail2 ]; then
        echo "OK"
        paste -d ":" $fail1 $fail2 > temp
	
	#loop milles loetakse faili reakaupa
        for rida in $(cat temp)
        do
		#nime lugemine failist
                kasutajanimi=$(echo "$rida" | cut -f1 -d:)
		#kasutaja lisamine
                useradd $kasutajanimi -m -s /bin/bash
		#parooli lisamine
                echo "$rida" | chpasswd #kasutajale vastav parool
		echo "$kasutajanimi kasutaja on lisatud"
        done

        else
                echo "probleem failiga $fail1 või $fail2"
        fi
#kontrolli lõpp
	#ajutise faili eemaldamine
	rm temp
fi

