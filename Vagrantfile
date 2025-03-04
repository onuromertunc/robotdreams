Vagrant.configure("2") do |config|

 
    # Build VM: jenkins
    config.vm.define "jenkins" do |jenkins|
      jenkins.vm.box = "ubuntu/focal64"
      jenkins.vm.box_download_insecure = true
  
      # Sabit IP ile Public Network
      jenkins.vm.network "public_network", ip: "192.168.1.13", bridge: "Realtek PCIe GbE Family Controller", auto_config: true
  
      # Port çakışmalarını önlemek için auto_correct
      jenkins.vm.network "forwarded_port", guest: 22, host: 2224, id: "ssh", auto_correct: true
  
      jenkins.vm.provider "virtualbox" do |vb|
        vb.memory = "4000"
        vb.cpus = 2
      end
  
      jenkins.vm.provision "shell", path: "setup-jenkins.sh", privileged: true
    end
  
  end
  