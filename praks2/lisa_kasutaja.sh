#!/bin/bash

#Lihtne kasutaja loomise skript
#Loeb käsurealt soovitud kasutajanime
read -p "Sisesta kasutajanimi: " nimi
#Lisame kasutaja vastavalt sisendile
useradd -m nimi -s /bin/bash
echo "Kasutaja lisatud"
