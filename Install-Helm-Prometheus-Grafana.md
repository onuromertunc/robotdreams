# 🚀 K3s Kubernetes Cluster Üzerine Prometheus ve Grafana Kurulumu

## 📌 1. Helm ile Prometheus & Grafana Kurulumu

### 🔹 1.1. Helm Repository’yi Ekleyin

Öncelikle **Helm repo’larını ekleyin ve güncelleyin**:

```sh
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

🔧 2. Prometheus & Grafana’yı Kurun

helm install prometheus-stack prometheus-community/kube-prometheus-stack \
  --namespace monitoring \
  --create-namespace

✅ 3. Kurulumu Kontrol Edin

kubectl get pods -n monitoring

🌍 4. Grafana’yı NodePort ile Açma

kubectl patch svc prometheus-stack-grafana -n monitoring -p '{"spec": {"type": "NodePort"}}'

🔍 4.1. NodePort ile Açılan Portu Bulun
kubectl get svc -n monitoring | grep grafana


🌐 5. Tarayıcıdan Grafana’ya Erişim
http://192.168.1.48:32345

🔑 6. Grafana Giriş Bilgileri

Grafana’nın varsayılan giriş bilgileri:

Kullanıcı Adı: admin

Şifre: prom-operator

📡 7. Prometheus’u Grafana’ya Bağlama

Grafana’ya giriş yaptıktan sonra:

Sol menüden → Configuration (Yapılandırma) → Data Sources (Veri Kaynakları) seçeneğine tıklayın.

Add Data Source (Veri Kaynağı Ekle) → Prometheus seçin.

http://prometheus-stack-kube-prom-prometheus.monitoring.svc:9090 adresini girin.

Save & Test butonuna basın.

Eğer bağlantı başarılı olursa "Data source is working" mesajını görmelisiniz. 🎯

Veya prometheus'uda nodeport ile dışarıya açın > http://192.168.1.49:31951/ bunun gibi bir ip adresiyle olmalı


---


