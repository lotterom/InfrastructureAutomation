#!/bin/bash

csv_file="subnetdata.csv"

#bestaat het opgegeven bestand?
if [ ! -f "$input_file" ]; then
    echo "Ongeldig bestand: $input_file bestaat niet."
    exit 1
fi

#overlooop csv en voeg config toe aan dhcpd.conf
while IFS=, read -r subnet start end; do
    echo "subnet $subnet netmask 255.255.255.0 {" >> /etc/dhcp/dhcpd.conf
    echo "  range $start $end;" >> /etc/dhcp/dhcpd.conf
    echo "}" >> /etc/dhcp/dhcpd.conf
done < "$input_file"

#reboot dhcp server
systemctl restart isc-dhcp-server

#confirm output
echo "DHCP-ranges toegevoegd aan dhcpd.conf en DHCP-server herstart."
