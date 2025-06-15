#!/bin/bash
set -e
# Apply n8n and Postgres secrets/config (run from the k3s-n8n directory)
kubectl apply -f n8n-config.yaml
kubectl apply -f n8n-secret.yaml
kubectl apply -f cloudnativepg-secret.yaml