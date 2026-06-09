#!/bin/bash

set -e

helm repo add argo https://argoproj.github.io/argo-helm
helm repo update

kubectl create namespace argocd --dry-run=client -o yaml | kubectl apply -f -

helm upgrade --install argocd argo/argo-cd \
  -n argocd \
  -f bootstrap/argocd-values.yaml

echo ""
echo "ArgoCD installation completed."