
#!/bin/bash
# kasutajate lisamise skript 


#kontroll kas on sisestatud fail
if [ $# -ne 1 ]; then
        echo "Kasutusjuhend: $0 fail1 "
else

        failinimi=$1

        #failide kontroll 
        if [ -f $failinimi -a -r $failinimi ]; then
        echo "OK"
	
	 for nimi in $(cat $failinimi)
    do
     	parool=$(tr -cd '[:alnum:]' < /dev/urandom | fold -w30 | head -n1)
	echo "$nimi"":""$parool" >> kasutajadparoolid
      
    done
        
	#loop milles loetakse faili reakaupa
        for rida in $(cat kasutajadparoolid)
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
                echo "probleem failiga $failinimi"
        fi
#kontrolli lõpp
echo "Paroolid on näha failis: kasutajadparoolid"
fi
