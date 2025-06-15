# K3s n8n Deployment

This repository provides Kubernetes manifests for deploying n8n on a K3s cluster using ArgoCD, with a hybrid approach for secret and config management.

## Deployment Flow

- **ArgoCD manages all stateless resources** (Deployment, Service, Ingress, etc.) in `n8n-app/`.
- **Sensitive resources (ConfigMap, Secrets)** are managed manually and are NOT included in the ArgoCD sync path. This keeps secrets out of Git and ArgoCD.

## Directory Structure

- `n8n-app/` — All ArgoCD-managed manifests (except secrets/config).
- `n8n-config.yaml` — ConfigMap for n8n (apply manually).
- `n8n-secret.yaml` — Secret for n8n (apply manually).
- `cloudnativepg-secret.yaml` — Secret for CloudNativePG/Postgres (apply manually).

## Getting Started

1. **Clone the repository**

```sh
git clone <your-repo-url>
cd k3s-n8n
```

2. **Apply secrets and config manually**

```sh
kubectl apply -f n8n-config.yaml
kubectl apply -f n8n-secret.yaml
kubectl apply -f cloudnativepg-secret.yaml
```

3. **Deploy the rest with ArgoCD**

- Point your ArgoCD Application at the `n8n-app/` directory.
- Sync the application in ArgoCD.

4. **Access n8n**

- Once deployed, access n8n via the configured ingress or service URL.

## Why this approach?

- **Secrets/config are not exposed in Git or managed by ArgoCD.**
- **ArgoCD manages all other resources for GitOps and automation.**
- **Easy to migrate to full GitOps/External Secrets in the future.**
