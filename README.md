# K8s-Insight-Tracker
Here’s a structured `README.md` file for your GitHub project that details the steps to set up the Kubernetes cluster, Helm installation, and deploy Prometheus, AlertManager, and Grafana:

```markdown
# Kubernetes Monitoring Setup with Prometheus, AlertManager, and Grafana

## Prerequisites

- **Google Cloud Platform (GCP) Account**: Ensure you have a GCP account.
- **gcloud CLI**: Make sure you have the Google Cloud SDK installed and configured.
- **kubectl**: Ensure you have kubectl installed for managing your Kubernetes cluster.
- **Helm**: This guide includes steps for installing Helm.

## Steps to Set Up

### 1. Create a GKE Cluster

Create a standard Google Kubernetes Engine (GKE) cluster. Note: Please do not create an autopilot cluster as it has certain restrictions.

```bash
gcloud container clusters create thecloudopscommunity \
    --release-channel=stable \
    --region=us-east1
```

### 2. Install Helm

Download and install Helm by running the following commands:

```bash
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh
```

### 3. Clone the Sample Application Repository

Clone the Bank of Anthos application repository:

```bash
git clone https://github.com/GoogleCloudPlatform/bank-of-anthos.git
cd bank-of-anthos/
```

### 4. Deploy OpenSource Prometheus, AlertManager, and Grafana

#### Deploy Prometheus and AlertManager

Add the Bitnami Helm repository and install Prometheus with AlertManager:

```bash
helm repo add bitnami https://charts.bitnami.com/bitnami
helm install tutorial bitnami/kube-prometheus \
    --version 8.2.2 \
    --values extras/prometheus/oss/values.yaml \
    --wait
```

#### Deploy Grafana

Add the Grafana Helm repository and install Grafana:

```bash
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update
helm install my-release grafana/grafana
```

### 5. Deploy the Sample Application (Bank of Anthos)

Apply the JWT secret and deploy the Kubernetes manifests:

```bash
kubectl apply -f extras/jwt/jwt-secret.yaml
kubectl apply -f kubernetes-manifests
```

### 6. Configure Slack for Alerts

#### Configure AlertManager

Create a Kubernetes secret for the Slack webhook:

```bash
kubectl create secret generic alertmanager-slack-webhook --from-literal webhookURL=SLACK_WEBHOOK_URL
kubectl apply -f extras/prometheus/oss/alertmanagerconfig.yaml
```

### 7. Configure Prometheus

Apply the necessary configurations for Prometheus:

```bash
kubectl apply -f extras/prometheus/oss/probes.yaml
kubectl apply -f extras/prometheus/oss/rules.yaml
```

### 8. Set Up Grafana Dashboard

Follow the Grafana UI instructions to create and configure your dashboard.


