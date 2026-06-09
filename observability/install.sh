#!/bin/bash

set -e

echo "Cleaning previous monitoring installation..."

helm uninstall monitoring -n observability >/dev/null 2>&1 || true

kubectl delete namespace observability --ignore-not-found=true --wait=true

echo "Cleaning leftover cluster-scoped resources..."

kubectl delete clusterrole,clusterrolebinding \
  -l app.kubernetes.io/instance=monitoring \
  --ignore-not-found=true

kubectl delete clusterrole monitoring-grafana-clusterrole --ignore-not-found=true
kubectl delete clusterrolebinding monitoring-grafana-clusterrolebinding --ignore-not-found=true


echo "Cleaning leftover kube-system monitoring services..."

kubectl delete svc -n kube-system \
  -l app.kubernetes.io/instance=monitoring \
  --ignore-not-found=true

kubectl delete svc monitoring-kube-prometheus-coredns \
  -n kube-system \
  --ignore-not-found=true

echo "Cleaning leftover admission webhooks..."

kubectl delete mutatingwebhookconfiguration monitoring-kube-prometheus-admission \
  --ignore-not-found=true

kubectl delete validatingwebhookconfiguration monitoring-kube-prometheus-admission \
  --ignore-not-found=true


echo "Cleaning previous metrics-server installation..."

kubectl delete -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml \
  --ignore-not-found=true || true

kubectl delete deployment metrics-server \
  -n kube-system \
  --force \
  --grace-period=0 \
  --ignore-not-found=true || true

echo "Waiting for metrics-server deployment to be fully removed..."

while kubectl get deployment metrics-server -n kube-system >/dev/null 2>&1; do
  echo "Waiting..."
  sleep 2
done

echo "Creating namespace..."

kubectl create namespace observability

echo "Adding Helm repository..."

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts >/dev/null 2>&1 || true
helm repo update

echo "Installing kube-prometheus-stack..."

helm upgrade --install monitoring \
  prometheus-community/kube-prometheus-stack \
  -n observability \
  -f observability/values/kube-prometheus-stack-values.yaml \
  --timeout 15m

echo ""
echo "Monitoring stack installed"
echo ""

kubectl get pods -n observability


echo "Installing metrics-server..."

kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml

kubectl patch deployment metrics-server \
  -n kube-system \
  --type='json' \
  -p='[
    {
      "op":"add",
      "path":"/spec/template/spec/containers/0/args/-",
      "value":"--kubelet-insecure-tls"
    }
  ]'

kubectl rollout status deployment/metrics-server -n kube-system