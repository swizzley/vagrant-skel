Vagrant.configure("2") do |config|

  config.vm.box = "swizzley88/centos-6.6-64_puppet-3.8"
  
    config.vm.provider "virtualbox" do |v|
  	  v.customize ["modifyvm", :id, "--memory", 4096]
  end
  
  config.vm.provision :puppet do |puppet|
    puppet.manifests_path = "provision"
    puppet.manifest_file = "baseline.pp"
  end
  
  config.vm.host_name = "core-vg-v1d"
  config.vm.network :private_network, type: "dhcp"
  config.vm.network :forwarded_port, guest: 8081, host: 8081, auto_corect: true
  config.vm.network :forwarded_port, guest: 8082, host: 8082, auto_corect: true
  config.vm.network :forwarded_port, guest: 8083, host: 8083, auto_corect: true
  config.vm.network :forwarded_port, guest: 8084, host: 8084, auto_corect: true
  
end
