Vagrant.configure("2") do |config|

  config.vm.box = "swizzley88/centos-6.6-64_puppet-3.8"
  
  config.vm.provision "puppet" do |puppet|
	  puppet.manifests_path = "provision"
	  puppet.manifest_file = "baseline.pp"
  end
  
  config.vm.provider "virtualbox" do |v|
  	  v.customize ["modifyvm", :id, "--memory", 4096]
  end
  
  config.vm.define "bus" do |bus|
    config.vm.host_name = "rmq-vg-v1d"
    config.vm.network :forwarded_port, guest: 15672, host: 15672
    config.vm.network :forwarded_port, guest: 5672, host: 5672
  end
  
  config.vm.define "bpa" do |bpa|
    config.vm.host_name = "bpa-vg-v1d"
  end
  
  config.vm.define "bpp" do |bpp|
    config.vm.host_name = "bpp-vg-v1d"
  end
  
  config.vm.define "bpo" do |bpo|
    config.vm.host_name = "pol-vg-v1d"
  end
  
  config.vm.define "hdp" do |hdp|
    config.vm.host_name = "hdp-vg-v1d"
	config.vm.network :forwarded_port, guest: 10000, host: 10000
	config.vm.network :forwarded_port, guest: 10020, host: 10020
	config.vm.network :forwarded_port, guest: 1004, host: 1004
	config.vm.network :forwarded_port, guest: 1006, host: 1006
	config.vm.network :forwarded_port, guest: 1060, host: 1060
	config.vm.network :forwarded_port, guest: 11000, host: 11000
	config.vm.network :forwarded_port, guest: 11001, host: 11001
	config.vm.network :forwarded_port, guest: 111, host: 111
	config.vm.network :forwarded_port, guest: 12000, host: 12000
	config.vm.network :forwarded_port, guest: 12001, host: 12001
	config.vm.network :forwarded_port, guest: 13562, host: 13562
	config.vm.network :forwarded_port, guest: 14000, host: 14000
	config.vm.network :forwarded_port, guest: 14001, host: 14001
	config.vm.network :forwarded_port, guest: 16000, host: 16000
	config.vm.network :forwarded_port, guest: 18080, host: 18080
	config.vm.network :forwarded_port, guest: 18081, host: 18081
	config.vm.network :forwarded_port, guest: 19888, host: 19888
	config.vm.network :forwarded_port, guest: 2049, host: 2049
	config.vm.network :forwarded_port, guest: 2181, host: 2181
	config.vm.network :forwarded_port, guest: 2181, host: 2181
	config.vm.network :forwarded_port, guest: 2888, host: 2888
	config.vm.network :forwarded_port, guest: 2888, host: 2888
	config.vm.network :forwarded_port, guest: 3181, host: 3181
	config.vm.network :forwarded_port, guest: 3888, host: 3888
	config.vm.network :forwarded_port, guest: 3888, host: 3888
	config.vm.network :forwarded_port, guest: 4181, host: 4181
	config.vm.network :forwarded_port, guest: 4242, host: 4242
	config.vm.network :forwarded_port, guest: 50010, host: 50010
	config.vm.network :forwarded_port, guest: 50020, host: 50020
	config.vm.network :forwarded_port, guest: 50030, host: 50030
	config.vm.network :forwarded_port, guest: 50060, host: 50060
	config.vm.network :forwarded_port, guest: 50070, host: 50070
	config.vm.network :forwarded_port, guest: 50075, host: 50075
	config.vm.network :forwarded_port, guest: 50090, host: 50090
	config.vm.network :forwarded_port, guest: 50470, host: 50470
	config.vm.network :forwarded_port, guest: 50495, host: 50495
	config.vm.network :forwarded_port, guest: 60000, host: 60000
	config.vm.network :forwarded_port, guest: 60010, host: 60010
	config.vm.network :forwarded_port, guest: 60020, host: 60020
	config.vm.network :forwarded_port, guest: 60030, host: 60030
	config.vm.network :forwarded_port, guest: 7077, host: 7077
	config.vm.network :forwarded_port, guest: 7078, host: 7078
	config.vm.network :forwarded_port, guest: 8019, host: 8019
	config.vm.network :forwarded_port, guest: 8020, host: 8020
	config.vm.network :forwarded_port, guest: 8021, host: 8021
	config.vm.network :forwarded_port, guest: 8030, host: 8030
	config.vm.network :forwarded_port, guest: 8031, host: 8031
	config.vm.network :forwarded_port, guest: 8032, host: 8032
	config.vm.network :forwarded_port, guest: 8033, host: 8033
	config.vm.network :forwarded_port, guest: 8040, host: 8040
	config.vm.network :forwarded_port, guest: 8041, host: 8041
	config.vm.network :forwarded_port, guest: 8042, host: 8042
	config.vm.network :forwarded_port, guest: 8080, host: 8080
	config.vm.network :forwarded_port, guest: 8085, host: 8085
	config.vm.network :forwarded_port, guest: 8088, host: 8088
	config.vm.network :forwarded_port, guest: 8480, host: 8480
	config.vm.network :forwarded_port, guest: 8485, host: 8485
	config.vm.network :forwarded_port, guest: 8888, host: 8888
	config.vm.network :forwarded_port, guest: 9010, host: 9010
	config.vm.network :forwarded_port, guest: 9083, host: 9083
	config.vm.network :forwarded_port, guest: 9090, host: 9090
	config.vm.network :forwarded_port, guest: 9090, host: 9090
	config.vm.network :forwarded_port, guest: 9095, host: 9095
	config.vm.network :forwarded_port, guest: 9290, host: 9290
  end
  
end
