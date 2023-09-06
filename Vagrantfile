# -*- mode: ruby -*-
# vim: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = "generic/debian10"
  config.vm.box_version = "4.2.16"
  config.vm.provider "virtualbox" do |v|
       v.memory = 512
       v.cpus = 1
    end

  config.vm.define "log" do |log|
    log.vm.network "private_network", ip: "192.168.50.10", virtualbox__intnet: "net1"
    log.vm.hostname = "log"
    log.vm.provision "shell", path: "log.sh"

  end
  config.vm.define "web" do |web|
    web.vm.network "private_network", ip: "192.168.50.11", virtualbox__intnet: "net1"
    web.vm.hostname = "web"
    web.vm.provision "shell", path: "web.sh"

  end

end
