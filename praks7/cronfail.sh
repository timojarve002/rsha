#!/bin/bash
#cron automatiseerimine

echo "SHELL = /bin/bash" > mycron
echo "MAILTO=root" >> mycron

#Jookseb iga 2 tunni tagant skripti
echo "0 */2 * * * root ~/rsha/praks6/kasutajad_db.sh user" >> mycron

#Jookseb iga päev 00:00
echo "0 0 * * * root ~/rsha/praks6/varunda_db_kasutaja.sh user" >> mycron

#lisame selle faili crontab-i
crontab mycron
#väljastab praeguse crontab-i
crontab -l
rm mycron
