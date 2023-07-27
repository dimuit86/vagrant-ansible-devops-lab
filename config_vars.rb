# config_vars.rb

# Golbal configuration variables
$vm_memory = 2048
$vm_cpus = 2
$vm_box = "generic/ubuntu2204"
$provision_script_path = "provision_scripts/setup_web_server.sh"

# VM configuration variables
$controller_ip = "192.168.122.160"
$jenkins_ip = "192.168.122.170"
$gitlab_ip = "192.168.122.180"
$k3sserver_ip = "192.168.122.190"
$k3sagent_ip = "192.168.122.200"
