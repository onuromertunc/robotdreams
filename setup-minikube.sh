#!/bin/bash

# Docker ve gerekli araçların yüklenmesi
sudo apt-get update
sudo ufw disable
sudo apt-get install -y ca-certificates curl gnupg lsb-release

# Docker kurulum adımları
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io

# Docker Compose yüklenmesi
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Kullanıcıyı Docker grubuna ekleme
sudo usermod -aG docker vagrant
sudo systemctl enable docker
sudo systemctl start docker

# Hostname değiştirme
echo "===================== Hostname değiştiriliyor... =========================="
sudo hostnamectl set-hostname minikube

# SSH ayarlarını düzenleme
echo "============= SSH ayarları yapılıyor ============="
sudo sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
sudo systemctl reload sshd

# Temel araçları yükleme
echo "============= Araçlar yükleniyor. ============="
sudo apt update
sudo apt install -y net-tools curl wget ufw fail2ban htop nmap openssh-server

echo "=============Minikube yükleniyor. ============="
curl -LO https://github.com/kubernetes/minikube/releases/latest/download/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube && rm minikube-linux-amd64
alias kubectl="minikube kubectl --"

#bu komutu vm'e login olduktan sonra non-root calistir.
minikube start --driver=docker





echo "===================== Kurulum Tamamlandı =========================="
