
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
