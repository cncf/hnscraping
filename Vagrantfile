# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  config.vm.box = "ubuntu/bionic64"
  config.vm.provision "shell", inline: "cd /vagrant && bin/provision", privileged: false, env: {"RACK_ENV" => "production"}
  config.vm.boot_timeout = 600

  config.vm.network "forwarded_port", guest: 80, host: 8080

  config.vm.provider "virtualbox" do |vb|
    vb.memory = "8192"
  end
end
