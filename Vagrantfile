Vagrant.configure("2") do |config|

  config.vm.define "elk_server" do |mon|
    mon.vm.box = "ubuntu/bionic64"
    mon.vm.hostname = "mon-server"
    mon.vm.network "public_network", ip: "192.168.1.83", bridge: "Realtek PCIe GbE Family Controller"

    mon.vm.provider "virtualbox" do |vb|
      vb.memory = 4096
      vb.cpus = 2
    end

    # SSH için bekleme süresi artırıldı
    config.vm.boot_timeout = 600

    mon.vm.provision "shell", inline: <<-SHELL
      # Firewall'u Tamamen Devre Dışı Bırakma
      sudo systemctl stop ufw
      sudo systemctl disable ufw

      # SSH Servisini Etkinleştirme
      sudo systemctl enable ssh
      sudo systemctl start ssh
      sudo sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
      sudo systemctl reload sshd

      # Zaman Senkronizasyonu
      sudo apt update
      sudo apt install -y ntp
      sudo systemctl enable ntp
      sudo systemctl start ntp

      # Prometheus Kurulumu
      sudo useradd --no-create-home --shell /bin/false prometheus
      sudo mkdir /etc/prometheus
      sudo mkdir /var/lib/prometheus

      sudo chown prometheus:prometheus /etc/prometheus
      sudo chown prometheus:prometheus /var/lib/prometheus

      # Prometheus Binary Dosyalarını İndirme
      wget https://github.com/prometheus/prometheus/releases/download/v2.47.0/prometheus-2.47.0.linux-amd64.tar.gz
      tar xvf prometheus-2.47.0.linux-amd64.tar.gz
      cd prometheus-2.47.0.linux-amd64

      sudo cp prometheus /usr/local/bin/
      sudo cp promtool /usr/local/bin/
      sudo cp -r consoles /etc/prometheus
      sudo cp -r console_libraries /etc/prometheus
      sudo cp prometheus.yml /etc/prometheus/prometheus.yml

      sudo chown -R prometheus:prometheus /etc/prometheus
      sudo chown prometheus:prometheus /usr/local/bin/prometheus
      sudo chown prometheus:prometheus /usr/local/bin/promtool

      # Prometheus Servis Dosyası
      echo "[Unit]" | sudo tee /etc/systemd/system/prometheus.service
      echo "Description=Prometheus Monitoring" | sudo tee -a /etc/systemd/system/prometheus.service
      echo "Wants=network-online.target" | sudo tee -a /etc/systemd/system/prometheus.service
      echo "After=network-online.target" | sudo tee -a /etc/systemd/system/prometheus.service
      echo "" | sudo tee -a /etc/systemd/system/prometheus.service
      echo "[Service]" | sudo tee -a /etc/systemd/system/prometheus.service
      echo "User=prometheus" | sudo tee -a /etc/systemd/system/prometheus.service
      echo "Group=prometheus" | sudo tee -a /etc/systemd/system/prometheus.service
      echo "Type=simple" | sudo tee -a /etc/systemd/system/prometheus.service
      echo "ExecStart=/usr/local/bin/prometheus \\\n            --config.file=/etc/prometheus/prometheus.yml \\\n            --storage.tsdb.path=/var/lib/prometheus/ \\\n            --web.console.templates=/etc/prometheus/consoles \\\n            --web.console.libraries=/etc/prometheus/console_libraries" | sudo tee -a /etc/systemd/system/prometheus.service
      echo "" | sudo tee -a /etc/systemd/system/prometheus.service
      echo "[Install]" | sudo tee -a /etc/systemd/system/prometheus.service
      echo "WantedBy=multi-user.target" | sudo tee -a /etc/systemd/system/prometheus.service

      # Prometheus Servisini Başlatma
      sudo systemctl daemon-reload
      sudo systemctl enable prometheus
      sudo systemctl start prometheus

      # Kurulum Tamamlandı Mesajı
      echo "Prometheus kurulumu tamamlandı."
    SHELL
  end
end
