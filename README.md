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



### 3. Deploy OpenSource Prometheus, AlertManager, and Grafana


#install helm first
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh



# Add Prometheus Helm repository and update
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

# Create namespace for Prometheus and install Prometheus
kubectl create ns monitoring
helm install prometheus prometheus-community/prometheus -n monitoring

# Add Grafana Helm repository and update
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update

# Create namespace for Grafana and install Grafana
kubectl create ns grafana
helm install grafana grafana/grafana -n grafana

# Optional: Get the Grafana admin password
echo "Grafana admin password:"
kubectl get secret --namespace grafana grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo

### 4. Deploy the Sample Application nginx and service 
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-app
spec:
  replicas: 2
  selector:
    matchLabels:
      app: nginx-app
  template:
    metadata:
      labels:
        app: nginx-app
    spec:
      containers:
        - name: nginx-app
          image: nginx:latest
          imagePullPolicy: Always
          ports:
            - containerPort: 80


### 5. Configure service to access application:

apiVersion: v1
kind: Service
metadata:
  name: nginx-app
spec:
  type: NodePort
  selector:
    app: nginx-app
  ports:
    - port: 80
      protocol: TCP
      targetPort: 80
      nodePort: 31001


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



