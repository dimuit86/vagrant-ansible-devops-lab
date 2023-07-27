# -*- mode: ruby -*-
# vi: set ft=ruby :
# Vagrantfile for provisioning virtual machines using Libvirt as the provider
# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!

#==========================================
# Title:   Streamlining Multi-Node Deployment with Vagrant and Libvirt
# Author:  DImuthu Daundasekara
# email:   digitalavenuelk@gmail.com
# Website: https://digitalavenue.dev
# Repo:     
#==========================================

# Set the minimum Vagrant version required
Vagrant.require_version ">= 2.2.0"

VAGRANTFILE_API_VERSION = "2"
ENV['VAGRANT_DEFAULT_PROVIDER']= 'libvirt'


# Load the configuration variables file
load File.join(File.dirname(__FILE__), "config_vars.rb")

# Use the Libvirt provider
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.provider "libvirt" do |rs|
    rs.memory = $vm_memory
    rs.cpus = $vm_cpus
  end

  # Will not check for box updates during every startup.
  config.vm.box_check_update = false

  # Define the virtual machine(s) here

  # Controller Node
  config.vm.define "controller" do |controller|
    controller.vm.box = $vm_box
    controller.vm.hostname = "controller.demo.com"
    controller.vm.network "private_network", ip:"192.168.122.160", auto_config: true, bridge: "virbr0", type: "virtio"
    controller.vm.provision "shell", path: "bootstrap.sh"

    # Copy "artifacts" directory from the local machine to the first virtual machine
    controller.vm.provision "file", source: "artifacts", destination: "/home/vagrant/"
    controller.vm.provision "shell", path: "artifacts/scripts/sshpass.sh"
    controller.vm.provision "shell", path: "artifacts/scripts/ansible.sh"

  end

  # Jenkins node
  config.vm.define "jenkins" do |jenkins|
    jenkins.vm.box = $vm_box
    jenkins.vm.hostname = "jenkins.demo.com"
    jenkins.vm.network "private_network", ip:"192.168.122.170", auto_config: true, bridge: "virbr0", type: "virtio"
    jenkins.vm.provision "shell", path: "bootstrap.sh"
  end

  # Gitlab node
  config.vm.define "gitlab" do |gitlab|
    gitlab.vm.box = $vm_box
    gitlab.vm.hostname = "gitlab.demo.com"
    gitlab.vm.network "private_network", ip:"192.168.122.180", auto_config: true, bridge: "virbr0", type: "virtio"
    gitlab.vm.provision "shell", path: "bootstrap.sh"
  end

  # K3S Master node
  config.vm.define "k3sserver" do |k3sserver|
    k3sserver.vm.box = $vm_box
    k3sserver.vm.hostname = "k3sserver.demo.com"
    k3sserver.vm.network "private_network", ip:"192.168.122.190"
  
    # Install net-tools
    k3sserver.vm.provision "shell",
      run: "once",
      inline: "sudo apt install net-tools"

    # Setting up default route
    k3sserver.vm.provision "shell", inline: <<-SHELL

      #!/bin/bash

      # Check if the script is being run as root
      if [[ $EUID -ne 0 ]]; then
        echo "This script must be run as root."
        exit 1
      fi

      # Check if the default route is associated with eth0
      current_default_route=$(ip route show default | awk '{print $5}')
      if [[ $current_default_route == "eth0" ]]; then
        # Get the gateway IP of eth1
        eth1_gateway=$(ip route show dev eth1 | awk '/default/ {print $3}')

        # Check if eth1 has a gateway IP assigned
        if [[ -z $eth1_gateway ]]; then
          # Assign "192.168.122.1" as the default gateway for eth1
          ip route add default via 192.168.122.1 dev eth1

          # Update the network interface configuration to make changes permanent
          echo "# Network interface configuration for eth1
          auto eth1
          iface eth1 inet static
            address <eth1_ip_address>
            netmask <eth1_subnet_mask>
            gateway 192.168.122.1" > /etc/network/interfaces.d/eth1

          echo "Default gateway set to 192.168.122.1 for eth1."
        else
          # Set up the new default route and default gateway to eth1
          ip route replace default via $eth1_gateway dev eth1

          # Update the network interface configuration to make changes permanent
          echo "# Network interface configuration for eth1
          auto eth1
          iface eth1 inet static
            address <eth1_ip_address>
            netmask <eth1_subnet_mask>
            gateway $eth1_gateway" > /etc/network/interfaces.d/eth1

          echo "Default route and gateway changed from eth0 to eth1 successfully."
        fi

        # Delete the default route from eth0
        ip route del default via $current_default_route dev eth0
      else
        echo "The default route does not belong to eth0. No changes made."
      fi

      exit 0

    SHELL

    k3sserver.vm.provision "shell", path: "bootstrap.sh"
  end

  # K3S Agent-01 Node
  config.vm.define "k3sagent" do |k3sagent|
    k3sagent.vm.box = $vm_box
    k3sagent.vm.hostname = "k3sagent.demo.com"
    k3sagent.vm.network "private_network", ip:"192.168.122.200", auto_config: true, bridge: "virbr0", type: "virtio"

    # Install net-tools
    k3sagent.vm.provision "shell",
      run: "once",
      inline: "sudo apt install net-tools"

    k3sagent.vm.provision "shell", inline: <<-SHELL

      #!/bin/bash

      # Check if the script is being run as root
      if [[ $EUID -ne 0 ]]; then
        echo "This script must be run as root."
        exit 1
      fi

      # Check if the default route is associated with eth0
      current_default_route=$(ip route show default | awk '{print $5}')
      if [[ $current_default_route == "eth0" ]]; then
        # Get the gateway IP of eth1
        eth1_gateway=$(ip route show dev eth1 | awk '/default/ {print $3}')

        # Check if eth1 has a gateway IP assigned
        if [[ -z $eth1_gateway ]]; then
          # Assign "192.168.122.1" as the default gateway for eth1
          ip route add default via 192.168.122.1 dev eth1

          # Update the network interface configuration to make changes permanent
          echo "# Network interface configuration for eth1
          auto eth1
          iface eth1 inet static
            address <eth1_ip_address>
            netmask <eth1_subnet_mask>
            gateway 192.168.122.1" > /etc/network/interfaces.d/eth1

          echo "Default gateway set to 192.168.122.1 for eth1."
        else
          # Set up the new default route and default gateway to eth1
          ip route replace default via $eth1_gateway dev eth1

          # Update the network interface configuration to make changes permanent
          echo "# Network interface configuration for eth1
          auto eth1
          iface eth1 inet static
            address <eth1_ip_address>
            netmask <eth1_subnet_mask>
            gateway $eth1_gateway" > /etc/network/interfaces.d/eth1

          echo "Default route and gateway changed from eth0 to eth1 successfully."
        fi

        # Delete the default route from eth0
        ip route del default via $current_default_route dev eth0
      else
        echo "The default route does not belong to eth0. No changes made."
      fi

      exit 0
    SHELL

    k3sagent.vm.provision "shell", path: "bootstrap.sh"
  end
end