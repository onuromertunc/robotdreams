Vagrant.configure("2") do |config|

 
  # Build VM: minikube
  config.vm.define "minikube" do |minikube|
    minikube.vm.box = "ubuntu/focal64"
    minikube.vm.box_download_insecure = true

    # Sabit IP ile Public Network
    minikube.vm.network "public_network", ip: "192.168.1.50", bridge: "Realtek PCIe GbE Family Controller", auto_config: true

    # Port çakışmalarını önlemek için auto_correct
    minikube.vm.network "forwarded_port", guest: 22, host: 2224, id: "ssh", auto_correct: true

    minikube.vm.provider "virtualbox" do |vb|
      vb.memory = "4000"
      vb.cpus = 2
    end

    minikube.vm.provision "shell", path: "setup-minikube.sh", privileged: true
  end

end
