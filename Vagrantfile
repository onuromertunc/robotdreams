Vagrant.configure("2") do |config|
  # ELK sunucusu
  config.vm.define "elk_server" do |elk|
    elk.vm.box = "ubuntu/bionic64"
    elk.vm.hostname = "elk-server"
    elk.vm.network "public_network", ip: "192.168.1.82", bridge: "Realtek PCIe GbE Family Controller"

    elk.vm.provider "virtualbox" do |vb|
      vb.memory = 4096
      vb.cpus = 2
    end

    # SSH için bekleme süresi artırıldı
    config.vm.boot_timeout = 600

    elk.vm.provision "shell", inline: <<-SHELL
      # Java Kurulumu (ElasticSearch ve Logstash için gerekli)
      sudo apt update
      sudo apt install -y openjdk-11-jdk wget apt-transport-https openssh-server

      # ElasticSearch Kurulumu
      wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
      echo "deb https://artifacts.elastic.co/packages/8.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-8.x.list
      sudo apt update
      sudo apt install -y elasticsearch
      echo 'xpack.security.enabled: false' | sudo tee -a /etc/elasticsearch/elasticsearch.yml
      sudo systemctl enable elasticsearch
      sudo systemctl start elasticsearch

      # Kibana Kurulumu
      sudo apt install -y kibana
      echo 'server.host: "0.0.0.0"' | sudo tee -a /etc/kibana/kibana.yml
      echo 'elasticsearch.hosts: ["http://localhost:9200"]' | sudo tee -a /etc/kibana/kibana.yml
      sudo systemctl enable kibana
      sudo systemctl start kibana

      # Logstash Kurulumu
      sudo apt install -y logstash
      sudo tee /etc/logstash/conf.d/logstash.conf > /dev/null <<EOL
      input {
        beats {
          port => 5044
        }
      }
      output {
        elasticsearch {
          hosts => ["http://localhost:9200"]
          index => "fluentbit-logs-%{+YYYY.MM.dd}"
        }
        stdout { codec => rubydebug }
      }
      EOL
      sudo systemctl enable logstash
      sudo systemctl start logstash

      # Firewall'u Tamamen Devre Dışı Bırakma
      sudo systemctl stop ufw
      sudo systemctl disable ufw

      # SSH Servisini Etkinleştirme
      sudo systemctl enable ssh
      sudo systemctl start ssh
      sudo sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
      sudo systemctl reload sshd

      # Zaman Senkronizasyonu
      sudo apt install -y ntp
      sudo systemctl enable ntp
      sudo systemctl start ntp

      # Sunucu Hazırlık Mesajı
      echo "Elastic Stack kurulumu tamamlandı."
    SHELL
  end
end
