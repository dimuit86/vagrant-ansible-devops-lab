#!/bin/bash
#==========================================
# Title:   Streamlining Multi-Node Deployment with Vagrant and Libvirt
# Author:  DImuthu Daundasekara
# email:   digitalavenuelk@gmail.com
# Website: https://digitalavenue.dev
# Repo:     
#==========================================

# Install ansible using pip only in controller node
if [[ $(hostname) = "controller" ]]; then
  apt-get install software-properties-common -y 
  apt-add-repository ppa:ansible/ansible -y
  apt-get install ansible -y
fi

# Install Jenkin in Jenkins node
if [[ $(hostname) = "controller" ]]; then
  sudo -H -u vagrant bash -c 'ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook ~/artifacts/ansible-setup/jenkins.yaml -i ~/artifacts/ansible-setup/inventory.ini' 
fi

# Install Jenkin in GitHub node
if [[ $(hostname) = "controller" ]]; then
  sudo -H -u vagrant bash -c 'ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook ~/artifacts/ansible-setup/gitlab-ce.yaml -i ~/artifacts/ansible-setup/inventory.ini' 
fi

# Install Jenkin in K3S Master node
if [[ $(hostname) = "controller" ]]; then
  sudo -H -u vagrant bash -c 'ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook ~/artifacts/ansible-setup/k3sserver.yaml -i ~/artifacts/ansible-setup/inventory.ini' 
fi

# Install Jenkin in K3S Agent node
if [[ $(hostname) = "controller" ]]; then
  sudo -H -u vagrant bash -c 'ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook ~/artifacts/ansible-setup/k3sagent.yaml -i ~/artifacts/ansible-setup/inventory.ini' 
fi