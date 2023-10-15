#!/bin/bash

csv_file="subnetdata.csv"

#bestaat het opgegeven bestand?
if [ ! -f "$input_file" ]; then
    echo "Ongeldig bestand: $input_file bestaat niet."
    exit 1
fi