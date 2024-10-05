# K8s-Insight-Tracker


Steps to be performed:
Setup a Kubernetes cluster
Helm installation
Deploy Opensource Prometheus and AlertManager using Helm
Deploy Grafana
Deploy a sample application to the cluster
Setup alerts using AlertManager and Slack
Setup Grafana dashboard
EFK stack setup (Work-in-progress)
Logging Setup (Work-in-progress)
Create a GKE cluster using cloud
Note: Please do not create the autopilot cluster as it will have some restrictions, you can use the standard GKE cluster

  gcloud container clusters create-auto thecloudopscommunity \
    --release-channel=stable \
    --region=us-east1
Helm installation
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh
Clone the application repo
git clone https://github.com/GoogleCloudPlatform/bank-of-anthos.git
cd bank-of-anthos/
Deploy Prometheus, AlertManager and Grafana
helm repo add bitnami https://charts.bitnami.com/bitnami
helm install tutorial bitnami/kube-prometheus \
--version 8.2.2 \
--values extras/prometheus/oss/values.yaml \
--wait

helm repo add grafana https://grafana.github.io/helm-charts
helm repo update
helm install my-release grafana/grafana
Deploy sample application Bank of Anthos
kubectl apply -f extras/jwt/jwt-secret.yaml
kubectl apply -f kubernetes-manifests
Configure Slack
Configure Alert manager
kubectl create secret generic alertmanager-slack-webhook --from-literal webhookURL=SLACK_WEBHOOK_URL
kubectl apply -f extras/prometheus/oss/alertmanagerconfig.yaml
Configure Prometheus
kubectl apply -f extras/prometheus/oss/probes.yaml
kubectl apply -f extras/prometheus/oss/rules.yaml
