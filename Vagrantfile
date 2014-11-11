# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.box = "ubuntu/trusty64"
  
  # Setup port forwarding
  config.vm.network "forwarded_port", guest: 80, host: 8000

  # Replace shell script for Ansible
  config.vm.provision "ansible" do |ansible|
  	ansible.playbook = "provision/vagrant.yml"
  end

end
