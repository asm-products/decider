# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = 'precise32'
  config.vm.network 'forwarded_port', guest: 3000, host: 3001
  config.ssh.forward_agent = true
  config.vm.provision 'shell', path: 'vagrant_privileged.sh', privileged: true
  config.vm.provision 'shell', path: 'vagrant.sh', privileged: false
end
