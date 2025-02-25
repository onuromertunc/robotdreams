#!/bin/bash

echo "===================== 1. Sunucu güncellemeleri yapılıyor... =========================="
#sudo apt update && sudo apt upgrade -y
sudo apt update -y

echo "===================== 2. root user aktif ediliyor ====================="
sudo su
sudo -i

echo "===================== 3. Swap devre dışı bırakılıyor... =========================="
sudo swapoff -a
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

echo "===================== 4. Firewall disable... =========================="

sudo ufw disable

# UFW durumunu görüntüleme
echo "===================== UFW durumu ====================="
sudo ufw status verbose


echo "===================== 5. Gerekli kernel modülleri yükleniyor... =========================="
sudo modprobe overlay
sudo modprobe br_netfilter

# Kernel ayarlarını yap
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF

# Kernel parametrelerini yeniden yükle
sudo sysctl --system


echo "===================== 6. Hostname değiştiriliyor... =========================="
sudo hostnamectl set-hostname k3sworker

echo "============= 7. ssh ayarları yapılıyor ============="
# Ssh ile baglanabilmek icin ssh/sshd_config dosyasi degistiriliyor.
sudo sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
sudo systemctl reload sshd


echo "============= 8. Araçlar yükleniyor. ============="
sudo apt update
sudo apt install net-tools curl wget -y
sudo apt install ufw fail2ban htop nmap -y
sudo apt install openssh-server -y
sudo apt install rsync tar -y

echo "============= 9. HELM INSTALL============="
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash


echo "192.168.1.48 k3smaster" | sudo tee -a /etc/hosts

echo "===================== 9. Reboot Ediliyor... =========================="  
sudo reboot
