# K3s Kubernetes Cluster Üzerine Prometheus ve Grafana Kurulumu

Bu doküman, **K3s Kubernetes cluster**'ında **Helm kullanarak Prometheus ve Grafana kurulumunu** adım adım açıklamaktadır.

---

## 🚀 1. Helm ile Prometheus & Grafana Kurulumu

### 📌 1.1. Helm Repository’yi Ekleyin

Öncelikle **Helm repo’larını ekleyin ve güncelleyin**:

```sh
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

## 🔧 2. Prometheus & Grafana’yı Kurun

helm install prometheus-stack prometheus-community/kube-prometheus-stack \
  --namespace monitoring \
  --create-namespace
