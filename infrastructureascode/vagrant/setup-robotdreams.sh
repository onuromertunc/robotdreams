#!/bin/bash
sudo apt-get update
sudo ufw disable
   sudo apt-get install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release -y
   curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
   echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
   sudo apt-get update
   sudo apt-get install docker-ce docker-ce-cli containerd.io -y
   sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
   sudo chmod +x /usr/local/bin/docker-compose


echo "===================== Hostname değiştiriliyor... =========================="
sudo hostnamectl set-hostname robotdreams

echo "============= ssh ayarları yapılıyor ============="
# Ssh ile baglanabilmek icin ssh/sshd_config dosyasi degistiriliyor.
sudo sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
sudo systemctl reload sshd

echo "============= Araçlar yükleniyor. ============="
sudo apt update
sudo apt install net-tools curl wget -y
sudo apt install ufw fail2ban htop nmap -y
sudo apt install openssh-server -y

# Docker imajını çalıştırma 
echo "===================== Docker imajı çalıştırılıyor... =========================="
docker run -d -p 7000:7000 onuromertunc/rd-helloworld:671

