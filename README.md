# How To Setup Complete DevOps Home Lab Using Vagrant on Ubuntu | Vagrant | Ansible | Jenkins | GitLab| Kubernetes | K3S

##  Home Lab Using Vagrant And Libvirt

This repository contains five node ansible lab setup using vagrant and Virtual Machine Manager (Libvirt) as the provider.

|    Node Type          | Node Name             |  IP Address     | OS Flavor         |
| ----------------------| --------------------- |-----------------|-------------------|
| Controller Node       | controller.demo.com   | 192.168.122.160 | generic/ubuntu2204|
| Jenkins Node          | jenkins.demo.com      | 192.168.122.170 | generic/ubuntu2204|
| GitLab Node           | gitlab.demo.com       | 192.168.122.180 | generic/ubuntu2204|
| K8S Master Node       | gitlab.demo.com       | 192.168.122.190 | generic/ubuntu2204|
| K8S Worker-01 Node    | gitlab.demo.com       | 192.168.122.200 | generic/ubuntu2204|

# An Introduction to Vagrant: Simplify Development Environments

At the end of this tutorial you will have a complete lab setup with Ansible Jenkins GitLab and a Kubernetes cluster.

## Introduction

Vagrant is a powerful command line utility for manage virtual machine lifecyle. this allows developers to run thier testing under a sandboxed and isolated envirment. which can create and manage lightweight, portable, and shareable virtual development environments in few seconds. we will explore the fundamentals of Vagrant, its various use cases, and its underlying structure.

## Usages of Vagrant

### 1. Cross-platform development

Vagrant can create a standardized environment that is independent of the host system. So, that you don't need to worriing about the inconsistencies since it allows developers to work on projects that need to run across multiple platforms.

### 2. Team collaboration

Team colaboration become more straightforward with Vagrant. Team members of the project will get exactly the same development environment, ensuring that everyone is working with the same setup, minimizing the "works on my machine" problem.

### 3. Testing and debugging

Vagrant enables developers to test their applications in isolated and sandboxed environments that closely mimic production setups. This facilitates efficient debugging and thorough testing, which leading to a more stable and robust end product before deadlines. 

### 4. Pre-built development environments

The Vagrant community offers a wide range of pre-configured boxes (base images) that contain various operating systems and software configurations.

Reference: [Vagrant Cloud](https://app.vagrantup.com/boxes/search) 

### 5. Continuous Integration (CI) and Continuous Deployment (CD)

Vagrant can be integrated into CI/CD pipelines, which can use as disposable and reproducible demo environments and allowing developers to run automated tests and deployment scripts.

## Vagrant Structure

Before moving further, Its crucial to understanding the basic structure of Vagrant.

The key components are as follows:

### 1. Vagrantfile

The Vagrantfile is the heart of a Vagrant project. It is a simple text file written in Ruby or Ruby DSL (Domain Specific Language). This file defines the configuration of the virtual machine, specifying the base box, provisioning scripts, network settings, and more. 

We can initialize our first vagrant virtualization project using "vagrant init" command,

```
vagrant init
```

Which will create sample Vagrantfile with all the nessary configurations. Then we need to custimize this file according to our needs.

Here's a minimal example of a Vagrantfile:

```ruby
Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/bionic64"
  config.vm.network "private_network", type: "dhcp"
end
```

### 2. Boxes

Vagrant box is a pre-configured virtual machine image that they typically contain a base operating system and may include additional software and configurations. 

These boxes are hosted on Vagrant Cloud or you can be create your own Vagrant boxed locally using tools like `vagrant package`.

Reference: [Vagrant Cloud](https://app.vagrantup.com/boxes/search) 

### 3. Providers

Vagrant supports multiple virtualization providers such as VirtualBox, VMware, Hyper-V, and more. Developers can choose the provider that best fits their needs. In this tutorial I'm going to use "Libvirt" as my virtualization provider as I'm demonstrating this on Ubuntu host machine.

Reference: [LibVirt](https://libvirt.org/) 

### 4. Provisioning

Vagrant allows for automated provisioning of the virtual machine. In order to perform additonal tasks, You can define scripts, Ansible playbooks and many more inside your Vagrantfile. It can be configured to use shell scripts, configuration management tools like Ansible, Puppet, or Chef, or even Docker containers for setting up the development environment. This ensures that the virtual machine is ready to use with all the required software and configurations.

### 5. Vagrant Commands

Vagrant provides a set of simple command-line tools to manage the virtual machine. Some common commands include:

- `vagrant up`: Creates and provisions the virtual machine based on the Vagrantfile.
- `vagrant ssh`: Opens an SSH session into the virtual machine.
- `vagrant halt`: Shuts down the virtual machine.
- `vagrant destroy`: Deletes the virtual machine while keeping the Vagrantfile intact.

# Creating a Virtual Home Lab with Vagrant and Libvirt: A Step-by-Step Guide for Ubuntu Users

Setting up a home lab using Vagrant with Libvirt as the provider and Virtual Machine Manager (VMM) on Ubuntu involves a few steps. Libvirt is a virtualization API that allows Vagrant to interact with various hypervisors, including KVM/QEMU, which are supported by Virtual Machine Manager on Ubuntu. Here's a step-by-step guide to help you get started:

**Note:** Before proceeding, ensure that you have Virtual Machine Manager (VMM) installed on your Ubuntu system.

### Step 1: Install Required Packages

First, you need to install the necessary packages for Vagrant and Libvirt. Open a terminal and run the following commands:

```bash
# Install Virtual Machine Manager (VMM) and Libvirt
sudo apt update
sudo apt install virt-manager libvirt-daemon-system libvirt-clients
```

### Step 2: Install Vagrant

Next, you'll install Vagrant on your Ubuntu machine:
Install Vagrant using the following commands:

```bash
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install vagrant
```

Reference: [Install Vagrant](https://www.vagrantup.com/downloads.html) 

### Step 3: Add Vagrant Libvirt Plugin

In order to enable Vagrant to work with Libvirt, you also need to install the Libvirt plugin. 
In the terminal, run this command.

```bash
vagrant plugin install vagrant-libvirt
```

### Step 4: Set Up Environment Variables

For Vagrant to use Libvirt, you must set up some environment variables. These variables will inform Vagrant to use Libvirt as the provider. Open your `.bashrc` file using a text editor:

```bash
nano ~/.bashrc
```

Add the following lines at the end of the file:

```bash
export VAGRANT_DEFAULT_PROVIDER=libvirt
export VAGRANT_LIBVIRT_URI=qemu:///system
```

Save and close the file, then reload the `.bashrc`:

```bash
source ~/.bashrc
```

### Step 5: Create a Vagrant Project

Now, you're ready to create your Vagrant project. Go to the directory where you want to store your Vagrant project and initialize a new Vagrant environment:

```bash
mkdir demo-lab
cd demo-lab
vagrant init
```

This will create a `Vagrantfile` in the current directory, which you can customize to configure your virtual machines.

### Step 6: Configure the Vagrantfile

Open the `Vagrantfile` using a text editor and customize it to your needs. You can choose the base box (Ubuntu, CentOS, etc.), set up network configurations, and provision the virtual machines. Below is an example of a basic Vagrantfile using the Ubuntu 20.04 box:

```ruby
Vagrant.configure("2") do |config|
  config.vm.box = "generic/ubuntu2004"
  config.vm.network "private_network", type: "dhcp"
end
```

Save the `Vagrantfile`.

### Step 7: Start the Virtual Machine

Finally, start the virtual machine using Vagrant:

```bash
vagrant up
```

Vagrant will download the specified base box (if not already present) and launch the virtual machine using Libvirt as the provider.

### Step 8: Interact with the Virtual Machine

Once the virtual machine is up and running, you can SSH into it using Vagrant:

```bash
vagrant ssh
```

You're now inside the virtual machine and can interact with it as if it were a regular Ubuntu machine.

### Step 9: Manage the Virtual Machine

You can use VMM (Virtual Machine Manager) to manage and monitor your virtual machines visually. Open Virtual Machine Manager from the application menu or run `virt-manager` in the terminal.

From the Virtual Machine Manager, you can start, stop, and modify the virtual machines created with Vagrant.

# Streamlining Multi-Node Deployment with Vagrant and Libvirt 

![Image: Streamlining Multi-Node Deployment with Vagrant and Libvirt](https://example.com/streamlining_multinode_deployment.jpg)

## Introduction

In this article, we will explore a Vagrantfile used to provision virtual machines for a multi-node environment and the associated scripts used for configuration. We will explain the essential parts of the code and how it sets up various nodes such as the controller, Jenkins, GitLab, K3S Master, and K3S Agent.

## Repository:

Before moving forward, you need to clone my reposiotiry from here.

### Clone Repository:
~~~bash
git clone 
~~~

## Understanding the Vagrantfile

The provided Vagrantfile exemplifies a multi-node deployment setup with five virtual machines, each serving a specific purpose:

1. **Controller Node:** Manages other nodes and acts as the central control point.
2. **Jenkins Node:** Provides Continuous Integration/Continuous Deployment (CI/CD) services.
3. **Gitlab Node:** Offers a private Git repository for version control.
4. **K3S Master Node:** Hosts the Kubernetes master for orchestrating containers.
5. **K3S Agent Node:** Acts as a worker node for Kubernetes container execution.

The Vagrantfile is a configuration file used by Vagrant, a tool for creating and managing virtualized development environments. The provided Vagrantfile uses the Libvirt provider to create virtual machines. Let's break down the essential parts of this Vagrantfile:

### 1. Vagrant API Version

The first line specifies the minimum Vagrant version required for compatibility:

```ruby
Vagrant.require_version ">= 2.2.0"
```

### 2. Load Configuration Variables**:

```ruby
load File.join(File.dirname(__FILE__), "config_vars.rb")
```
  
This line loads the configuration variables from the "config_vars.rb" file. It allows externalizing settings like the VM box, memory, and CPU configurations.


### 3. Libvirt as the Provider

The Vagrantfile uses Libvirt as the provider for virtual machines:
This sets the default provider to Libvirt, which is a popular virtualization solution for Linux.

```ruby
ENV['VAGRANT_DEFAULT_PROVIDER']= 'libvirt'
```

### 4. Defining Virtual Machines

```ruby
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # ... VM definitions ...
end
```

The configuration block where virtual machines are defined. Each virtual machine is specified using the `config.vm.define` block.

### 5. VM Definitions

```ruby
config.vm.define "controller" do |controller|
  # ... VM settings and provisioning ...
end
```

Each VM is defined using `config.vm.define` followed by the VM's name. Inside the block, you set various properties, such as the box, hostname, IP address, network settings, and provisioning scripts.

### 6. Node Definitions

Each node is defined using the `config.vm.define` block. For instance, the definition of the "Controller Node" looks like this:

```ruby
config.vm.define "controller" do |controller|
  # Configuration for controller node
end
```

### 7. Networking

The Vagrantfile sets up a private network for each node with assigned IP addresses:

```ruby
controller.vm.network "private_network", ip:"192.168.122.160", auto_config: true, bridge: "virbr0", type: "virtio"
```

### 8. Provisioning

Provisioning scripts, located in the "provision" directory, install necessary packages and configurations on each node:

```ruby
controller.vm.provision "shell", path: "bootstrap.sh"
```

**Provisioning Scripts: boostrap.sh, sshpass.sh, ansible.sh**

The Vagrantfile defines several VMs with different roles. To configure these VMs, it uses three shell scripts: bootstrap.sh, sshpass.sh, and ansible.sh. Let's look at what each script does:

1. **bootstrap.sh**:
   This script updates the login message, updates the hosts entries with IP and hostname mappings for each VM, and installs common packages like curl, wget, net-tools, and sshpass.

2. **sshpass.sh**:
   This script is used to generate an SSH key pair locally and distribute the public key to the specified servers. It reads a list of server IP addresses from the "vms_list.txt" file and checks the availability of each server before distributing the SSH key.

3. **ansible.sh**:
   This script is responsible for installing Ansible and running Ansible playbooks to configure various nodes in the environment. It first installs Ansible on the "controller" node using apt. Then, it runs separate Ansible playbooks to set up Jenkins, GitLab, K3S Master, and K3S Agent nodes on their respective VMs.

## Running the Multi-Node Setup

To deploy the multi-node setup, navigate to the directory containing the Vagrantfile and execute:

```bash
vagrant up
```

Vagrant will automatically create and provision the virtual machines according to the Vagrantfile.

**Conclusion**

In this article, we explored a Vagrantfile and associated provisioning scripts used to create and configure a multi-node virtual environment. The Vagrantfile defines different VMs with their configurations, and the scripts are used to set up the necessary software and configurations on each VM. This allows developers and system administrators to quickly create a development environment with multiple interconnected nodes, suitable for various projects and testing scenarios.

Please note that the provided code and scripts are for demonstrative purposes only and should not be used in a production environment. Always ensure to review and customize any configurations to suit your specific use case and security requirements.

```bash
;==========================================
; Title:   Streamlining Multi-Node Deployment with Vagrant and Libvirt
; Author:  DImuthu Daundasekara
; email:   digitalavenuelk@gmail.com
; Website: https://digitalavenue.dev
; Repo:     
;==========================================
```