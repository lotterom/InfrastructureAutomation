#!/bin/bash

# uitvoeren van script -> bash backupFolder.sh /pad/naar/te/back-uppen/map
if [ $# -ne 1 ]; then
    echo "Gebruik: $0 <map_om_te_back-uppen>"
    exit 1
fi

#bestaat path?
if [ ! -d "$1" ]; then
    echo "Ongeldige map: $1 "
    exit 1
fi

#naam back-up (datum en tijd)
backup_filename="backup_$(date +%Y%m%d_%H%M%S).tar.gz"

#map opslaan
tar -czvf "$backup_filename" "$1"

echo "Back-up succesvol: $backup_filename"

#cron job voor elke zondag om 17:00 uur
#a cron job is any defined task to run in a given time period. 
#It can be a shell script or a simple bash command. Cron job helps us automate our routine tasks
(crontab -l 2>/dev/null; echo "0 17 * * 0 /path/naar/backup_script.sh $1") | crontab -

echo "Cron job ingesteld (elke zondag om 17u) "
