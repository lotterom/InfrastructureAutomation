def generate_router_config(csv_file):
    config = ""

# headers csv
# network,	interface,	description,	vlan,	ipaddress,	subnetmask,	defaultgateway
    with open(csv_file, newline='') as csvfile:
        reader = csv.DictReader(csvfile)
        for row in reader:
            if row['network']:
                config += "\n"
            if row['interface']:
                    config += f"interface {row['interface']}\n"
            if row['description']:
                    config += f"description {row['description']}\n"
            if row['vlan']:
                    config += f"vlan {row['vlan']}\n"
            if row['ipaddress'] and row['subnetmask']:
                    config += f"ip address {row['ipaddress']} {row['subnetmask']}\n"
            if row['defaultgateway']:
                    config += f"ip default-gateway {row['defaultgateway']}\n"
            else:
                  print("Er ging iets mis met het uitlezen van router_config.csv")

    return config

def write_config_to_file(config, filename):
    with open(filename, 'w') as file:
        file.write(config)

import csv

# genereer config
router_config = generate_router_config('InfrastructureAutomation/Python/router_config.csv')

# schrijf config naar bestand
write_config_to_file(router_config, "router_config.txt")
