# -*- mode: ruby -*-
# vi: set ft=ruby :

VFP_NAME = 'vagrant-forward-ports-test'

Vagrant.configure("2") do |config|
  config.vm.box = 'ubuntu/xenial64'
  config.vm.hostname = VFP_NAME

  config.vm.synced_folder '.', '/vagrant', disabled: true

  config.vm.provider 'virtualbox' do |vb, override|
    vb.name = VFP_NAME

    vb.memory = 512
    vb.cpus = 1
  end

  config.forward_ports.maps do |maps|
    maps.reverse '80', '127.0.0.1:80'
  end
end
