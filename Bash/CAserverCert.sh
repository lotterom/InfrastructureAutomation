#!/bin/bash

# Controleer of het script als root wordt uitgevoerd
if [[ $EUID -ne 0 ]]; then
   echo "Dit script moet als root worden uitgevoerd" 
   exit 1
fi

# Installeer OpenSSL indien nodig
apt-get install -y openssl

# Genereer het CA-certificaat en -sleutel
openssl genrsa -des3 -out ca.key 2048
openssl req -new -x509 -days 1826 -key ca.key -out ca.crt <<EOF
BE
West-Vl
Kortrijk
Howest
MCT
lotte
lotte@gmail.com
EOF

# Genereer de server privésleutel
openssl genrsa -out server.key 2048

# Genereer de CSR (Certificate Signing Request) voor het servercertificaat
openssl req -new -out server.csr -key server.key <<EOF
BE
West-Vl
Kortrijk
Howest
IoT
lotte
lotte@gmail.com
EOF

# Onderteken de CSR met het CA-certificaat om het servercertificaat te verkrijgen
openssl x509 -req -in server.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out server.crt -days 360

# Verwijder het wachtwoord uit de CA-sleutel (optioneel)
openssl rsa -in ca.key -out ca.key

echo "Certificaten zijn aangemaakt: ca.crt, ca.key, server.crt, server.key, server.csr"
