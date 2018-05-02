
#!/bin/bash
#
# kasutajate lisamise skript failist paroolidega
if [ $# -ne 2 ]; then
        echo "Kasutusjuhend: $0 fail1 fail2"
	echo "Fail1 kasutajad, fail2 paroolid"
else

	fail1=$1
	fail2=$2

        if [ -f $fail1 -a -r $fail1 ]; then
        echo "OK"

        for rida in $(cat $fail1)
        do
	kasutajanimi=$(echo "$rida")
	parool=$(cat $fail2)

	useradd $kasutajanimi -m -s /bin/bash
	echo "$rida:$parool" | chpasswd

        done

	else
                echo "probleem failiga $fail1"
        fi
#kontrolli lõpp
fi

