Vagrant.configure("2") do |config|
    config.vm.box = "centos/7"
    config.vm.hostname = "BuildMachine"
    config.vm.define "BuildMachine"
    config.vm.network :public_network, bridge: "wlp6s0"
    config.vm.provider "virtualbox" do |vb|
      vb.memory = "2048"
    end
    config.vm.synced_folder ".", "/mnt/share"
    config.vm.provision "shell", path: "scripts/angular_install.sh"
    config.vm.provision "shell", path: "scripts/docker_install.sh"
    config.vm.provision "shell", path: "scripts/install_google_chrome.sh"
  end
