#!/bin/bash
#==========================================
# Title:   Streamlining Multi-Node Deployment with Vagrant and Libvirt
# Author:  DImuthu Daundasekara
# email:   digitalavenuelk@gmail.com
# Website: https://digitalavenue.dev
# Repo:     
#==========================================

SERVERS_LIST="/home/vagrant/artifacts/config/vms_list.txt"

# Function to generate an SSH key pair locally
generate_ssh_key() {
    echo "Generating SSH key pair locally..."
    # ssh-keygen -t rsa -b 4096 -C "your_email@example.com" -f ~/.ssh/id_rsa -N ""
    echo vagrant | sudo -u vagrant ssh-keygen -t rsa -b 4096 -f /home/vagrant/.ssh/id_rsa -q -N ""
}

# Function to check if a server is up and running
check_server_availability() {
    local server_ip=$1
    echo "Checking server: $server_ip"
    while ping -c1 "$server_ip" &>/dev/null; do
        echo "Server is not up yet. Waiting 60 seconds..."
        sleep 60
        exit 0
    done
    echo "Server is up and running."
}

# Function to distribute the SSH public key to a server
distribute_ssh_key() {
    local server_ip=$1
    local ssh_user="vagrant"  # Replace with your SSH username
    local ssh_key_path="/home/vagrant/.ssh/id_rsa.pub"    # Path to the public key file
    echo "Distributing SSH key to server: $server_ip"
    echo vagrant | sudo -S su - vagrant -c "sshpass -p vagrant ssh-copy-id -f -i "$ssh_key_path" -o "StrictHostKeyChecking=no" "$ssh_user@$server_ip""
}

# Generate SSH key pair locally
generate_ssh_key

# Check servers' availability from the file "server_list.txt"
while read -r server_ip; do
    check_server_availability "$server_ip"
    distribute_ssh_key "$server_ip"
done < $SERVERS_LIST # server_list.txt

echo "SSH key distribution completed successfully."
