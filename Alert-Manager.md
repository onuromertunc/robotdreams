# Alertmanager Kurulumu ve Konfigürasyonu (Ubuntu)

## 📌 Giriş
Bu doküman, **Prometheus Alertmanager**'ı **Ubuntu sunucusunda** nasıl kurup yapılandıracağını adım adım açıklar. Alertmanager, Prometheus'un **alarm yönetimi bileşeni** olup, e-posta, Slack, PagerDuty ve diğer servislerle entegre çalışarak bildirimler göndermeyi sağlar.

## 🚀 1. Alertmanager Kurulumu

### **1️⃣ Alertmanager'ı İndir ve Kur**
```bash
cd /opt
wget https://github.com/prometheus/alertmanager/releases/download/v0.28.1/alertmanager-0.28.1.linux-amd64.tar.gz
```

### **2️⃣ Dosyaları Çıkart ve Taşı**
```bash
tar -xvf alertmanager-0.28.1.linux-amd64.tar.gz
mv alertmanager-0.28.1.linux-amd64 /usr/local/bin/alertmanager
```

### **3️⃣ Kullanıcı ve Dizinleri Oluştur**
```bash
useradd --no-create-home --shell /bin/false alertmanager
mkdir /etc/alertmanager
mkdir /var/lib/alertmanager
chown -R alertmanager:alertmanager /etc/alertmanager /var/lib/alertmanager
```

## ⚙️ 2. Alertmanager Konfigürasyonu

### **1️⃣ Konfigürasyon Dosyasını (`alertmanager.yml`) Oluştur**
```bash
nano /etc/alertmanager/alertmanager.yml
```

Aşağıdaki içeriği ekleyin (**Gmail SMTP Kullanımı İçin Güncellendi**):
```yaml
global:
  resolve_timeout: 5m

route:
  receiver: "email-notification"

receivers:
  - name: "email-notification"
    email_configs:
      - to: "senin-email@gmail.com"
        from: "senin-email@gmail.com"
        smarthost: "smtp.gmail.com:587"
        auth_username: "senin-email@gmail.com"
        auth_password: "buraya-uygulama-sifreni-yaz"
        require_tls: true
        tls_config:
          insecure_skip_verify: false
```

### **2️⃣ Dosya Yetkilerini Ayarla**
```bash
chown alertmanager:alertmanager /etc/alertmanager/alertmanager.yml
chmod 600 /etc/alertmanager/alertmanager.yml
```

## 🔄 3. Alertmanager Servisini Başlatma

### **1️⃣ Systemd Servis Dosyasını (`alertmanager.service`) Oluştur**
```bash
nano /etc/systemd/system/alertmanager.service
```

Aşağıdaki içeriği ekleyin:
```ini
[Unit]
Description=Prometheus Alertmanager
Wants=network-online.target
After=network-online.target

[Service]
User=alertmanager
Group=alertmanager
Type=simple
ExecStart=/usr/local/bin/alertmanager/alertmanager \
  --config.file=/etc/alertmanager/alertmanager.yml \
  --storage.path=/var/lib/alertmanager
Restart=always

[Install]
WantedBy=multi-user.target
```

### **2️⃣ Servisi Başlat ve Otomatik Başlatmayı Aç**
```bash
systemctl daemon-reload
systemctl enable alertmanager
systemctl start alertmanager
```

Servis durumunu kontrol etmek için:
```bash
systemctl status alertmanager
```

## 🔗 4. Prometheus ile Entegrasyon

Prometheus'un Alertmanager ile iletişim kurabilmesi için, Prometheus konfigürasyonuna (`prometheus.yml`) şu satırları ekleyin:
```yaml
alerting:
  alertmanagers:
    - static_configs:
        - targets: ["localhost:9093"]
```

Prometheus'u yeniden başlatın:
```bash
systemctl restart prometheus
```

## 🛠️ 5. Alert Testi

### **1️⃣ Fake Alert Tanımla**
```bash
nano /etc/prometheus/alerts.yml
```

Şu kuralları ekleyin:
```yaml
groups:
  - name: test-alerts
    rules:
      - alert: HighCPUUsage
        expr: process_cpu_seconds_total > 0
        for: 1m
        labels:
          severity: critical
        annotations:
          summary: "High CPU Usage Detected!"
          description: "CPU usage exceeded threshold"
```

`prometheus.yml` dosyasına **`alerts.yml` dosyasını** dahil edin:
```yaml
rule_files:
  - "/etc/prometheus/alerts.yml"
```

Prometheus'u yeniden başlatın:
```bash
systemctl restart prometheus
```

### **2️⃣ Manuel Alert Kontrolü**
```bash
curl http://localhost:9090/api/v1/alerts | jq
```

Eğer e-posta gelmezse, logları kontrol edin:
```bash
journalctl -u alertmanager --no-pager | tail -n 50
```
