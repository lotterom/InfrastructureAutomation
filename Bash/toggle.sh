#!/bin/bash

# DHCP inschakelen
enable_dhcp() {
    echo "Enable DHCP"
    ifconfig eth0 dhcp
    echo "DHCP is ingeschakeld"
}

# statisch IP instellen
set_static_ip(){
    read -p "Voer ip adres in: " ip_address
    read -p "Voer subnetmasker in: " subnet_mask
    read -p "Voer gateway in: " gateway

    echo " Statisch IP..."
    ifconfig eth0 $ip_address netmask $subnet_mask
    route add default gw $gateway
    echo "Statisch IP is ingesteld"
}

# Hoofdmenu
echo "1. Schakel DHCP in"
echo "2. Stel statisch IP in"

read -p "Maak een keuze (1 of 2): " choice

case $choice in
    1)
        enable_dhcp
        ;;
    2)
        set_static_ip
        ;;
    *)
        echo "Ongeldige keuze. Voer 1 of 2 in."
        ;;
esac
