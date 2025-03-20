📌 K3s Kubernetes Cluster Üzerine Prometheus ve Grafana Kurulumu
Bu doküman, K3s Kubernetes cluster'ında Helm kullanarak Prometheus ve Grafana kurulumunu adım adım açıklamaktadır.

🚀 1. Helm ile Prometheus & Grafana Kurulumu
📌 1.1. Helm Repository’yi Ekleyin
Öncelikle Helm repo’larını ekleyin ve güncelleyin:

sh
Kopyala
Düzenle
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
🔧 2. Prometheus & Grafana’yı Kurun
Aşağıdaki komutla kube-prometheus-stack Helm Chart’ını yükleyin:

sh
Kopyala
Düzenle
helm install prometheus-stack prometheus-community/kube-prometheus-stack \
  --namespace monitoring \
  --create-namespace
Bu komut, Kubernetes cluster’ına Prometheus, Grafana, Alertmanager ve ilgili bileşenleri yükler.

✅ 3. Kurulumu Kontrol Edin
Pod’ların çalıştığını doğrulamak için aşağıdaki komutu çalıştırın:

sh
Kopyala
Düzenle
kubectl get pods -n monitoring
Beklenen çıktı:

cpp
Kopyala
Düzenle
NAME                                                      READY   STATUS    RESTARTS   AGE
prometheus-stack-grafana-xxxxx-xxxxx                     1/1     Running   0          1m
prometheus-stack-kube-state-metrics-xxxxx-xxxxx         1/1     Running   0          1m
prometheus-stack-prometheus-node-exporter-xxxxx-xxxxx   1/1     Running   0          1m
prometheus-stack-alertmanager-xxxxxxx-xxxxx             2/2     Running   0          1m
prometheus-stack-prometheus-xxxxxxx-xxxxx               2/2     Running   0          1m
Eğer tüm pod’lar Running durumundaysa, kurulum başarılıdır. 🚀

🌍 4. Grafana’yı NodePort ile Açma
Grafana’ya dışarıdan erişebilmek için servisini NodePort olarak ayarlayın:

sh
Kopyala
Düzenle
kubectl patch svc prometheus-stack-grafana -n monitoring -p '{"spec": {"type": "NodePort"}}'
🔍 4.1. NodePort ile Açılan Portu Bulun
Grafana’nın hangi portta çalıştığını görmek için:

sh
Kopyala
Düzenle
kubectl get svc -n monitoring | grep grafana
Örnek çıktı:

cpp
Kopyala
Düzenle
prometheus-stack-grafana       NodePort    10.43.155.236    <none>        80:32345/TCP   5m
Buradaki 32345, NodePort tarafından atanmış porttur.

🌐 5. Tarayıcıdan Grafana’ya Erişim
Aşağıdaki adresten Grafana’ya erişebilirsiniz:

cpp
Kopyala
Düzenle
http://192.168.1.48:32345
Eğer worker node’a erişmek istiyorsanız, 192.168.1.49:32345 adresini kullanabilirsiniz.

🔑 6. Grafana Giriş Bilgileri
Grafana’nın varsayılan giriş bilgileri:

Kullanıcı Adı: admin

Şifre: prom-operator

Eğer şifreyi öğrenmek isterseniz:

sh
Kopyala
Düzenle
kubectl get secret -n monitoring prometheus-stack-grafana -o jsonpath="{.data.admin-password}" | base64 --decode
📡 7. Prometheus’u Grafana’ya Bağlama
Grafana’ya giriş yaptıktan sonra:

Sol menüden → Configuration (Yapılandırma) → Data Sources (Veri Kaynakları) seçeneğine tıklayın.

Add Data Source (Veri Kaynağı Ekle) → Prometheus seçin.

http://prometheus-stack-kube-prom-prometheus.monitoring.svc:9090 adresini girin.

Save & Test butonuna basın.

Eğer bağlantı başarılı olursa "Data source is working" mesajını görmelisiniz. 🎯
