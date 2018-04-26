#!/bin/bash
#
# lihtne kasutajate lisamise skript
if [ $# -ne 1 ]; then
    echo "Kasutusjuhend: käsk failinimi"
else
	failinimi=$1
  if [ -f $failinimi -a -r $failinimi ]; then
    echo "OK"
    for nimi in $(cat $failinimi)
    do
      # sellega peaks faili sisu olema nähtav, kui fail on kätte saadav ja nüüd echo asemel tuleb kutsuda vajalik skript

      sh lisa_kasutaja.sh $nimi # sellega me laseme lisa_kasutaja skript tööle
    done
  else
    echo "probleem failiga $failinimi"
  fi
# kontrolli lõpp
fi
