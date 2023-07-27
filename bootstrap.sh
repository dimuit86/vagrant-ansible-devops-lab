#!/usr/bin/env bash
#==========================================
# Title:   Streamlining Multi-Node Deployment with Vagrant and Libvirt
# Author:  DImuthu Daundasekara
# email:   digitalavenuelk@gmail.com
# Website: https://digitalavenue.dev
# Repo:     
#==========================================

# Update login message
sudo echo -e "Welcome Back!"  | sudo tee -a /etc/motd
sudo cp .banner /etc/ssh/.banner
sudo sed -i 's!#Banner none!Banner /etc/ssh/.banner!g' /etc/ssh/sshd_config

# Update hosts entries
echo -e "192.168.122.160 controller.demo.com controller\n
         192.168.122.170 jenkins.demo.com jenkins\n
         192.168.122.180 gitlab.demo.com gitlab\n
         192.168.122.190 k3sserver.demo.com k3sserver\n
         192.168.122.200 k3sagent.demo.com k3sagent" >> /etc/hosts

# Update the system
apt -y update 

# Install Common packages
apt-get install curl wget net-tools iputils-ping sshpass -y