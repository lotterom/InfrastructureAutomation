from netmiko import ConnectHandler
import csv
import os

# SSH connectie
def connect_to_device(device_info):
    connection = ConnectHandler(**device_info)
    return connection

# commando's op switch
def send_commands(connection, commands):
    output = connection.send_config_set(commands)
    return output

# TFTP
def write_to_tftp_server(connection, tftp_server, filename):
    command = f"write tftp://{tftp_server}/{filename}"
    output = connection.send_command_timing(command)
    return output

def disconnect(connection):
    connection.disconnect()

# CSV lezen + voer config uit
def configure_switch(csv_file):
    with open(csv_file, newline='') as csvfile:
        reader = csv.DictReader(csvfile)
        for row in reader:
            connection = connect_to_device({
                'device_type': 'cisco_ios',
                'ip': row['ip address'],
                'username': 'cisco',
                'password': 'cisco',
                #port optioneel --> default poort 22
            })

            if row['vlan'] and row['ip address'] and row['subnetmask']:
                # Layer-3
                commands = [
                    f"vlan {row['vlan']}",
                    f"description {row['description']}",
                    f"ip address {row['ip address']} {row['subnetmask']}"
                ]
                send_commands(connection, commands)
            elif row['vlan']:
                # Layer-2
                commands = [
                    f"vlan {row['vlan']}",
                    f"description {row['description']}"
                ]
                send_commands(connection, commands)

            if row['ip address'] and row['subnetmask']:
                commands = [
                    "ip routing"
                ]
                send_commands(connection, commands)

            if row['description'].lower().find('trunk') != -1 or row['description'].lower().find('uplink') != -1:
                # trunk
                commands = [
                    f"interface {row['ports']}",
                    "switchport mode trunk"
                ]
                send_commands(connection, commands)

            if row['vlan']:
                commands = [
                    f"interface {row['ports']}",
                    f"switchport trunk allowed vlan {row['vlan']}"
                ]
                send_commands(connection, commands)

            if row['ip address'] and row['subnetmask']:
                commands = [
                    f"ip default-gateway {row['ip address']}"
                ]
                send_commands(connection, commands)

            disconnect(connection)

# TFTP
def start_tftp_server_and_download_config(tftp_server, filename):
    os.system(f"start_tftp_server_command {tftp_server} &")
    os.system(f"download_config_command {filename}")

#functie cinfig switch uitvoeren
configure_switch('switch_config.csv')#naam csv
#TFTP functie uitvoeren
start_tftp_server_and_download_config('192.168.10.12', 'switch_config.txt')#ip van tftp server, naam bestand
