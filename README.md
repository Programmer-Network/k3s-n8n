# K3s n8n Deployment

This repository provides Kubernetes manifests for deploying n8n on a K3s cluster using ArgoCD, with a hybrid approach for secret and config management.

## Data Persistence

This deployment ensures data persistence through two mechanisms:

1. **PostgreSQL Database (CloudNativePG)**

   - Stores workflow data, credentials, and execution history
   - Uses Longhorn for reliable storage (10GB allocated)
   - Automatic user creation and secure credential management
   - Database credentials managed by CloudNativePG operator

2. **Local n8n Data (PersistentVolumeClaim)**
   - Stores local configuration and authentication data
   - Uses Longhorn for reliable storage (1GB allocated)
   - Maintains user sessions across pod restarts
   - Proper permissions (600) for security

## Deployment Flow

- **ArgoCD manages all stateless resources** (Deployment, Service, Ingress, etc.) in `n8n-app/`.
- **Sensitive resources (ConfigMap, Secrets)** are managed manually and are NOT included in the ArgoCD sync path. This keeps secrets out of Git and ArgoCD.

## Directory Structure

- `n8n-app/` — All ArgoCD-managed manifests (except secrets/config)
  - `cloudnativepg-cluster.yaml` - PostgreSQL database configuration
  - `n8n-deployment.yaml` - Main n8n deployment with persistence
  - `n8n-pvc.yaml` - Persistent storage for n8n data
- `n8n-config.yaml` — ConfigMap for n8n (apply manually)
- `n8n-secret.yaml` — Secret for n8n (apply manually)
- `cloudnativepg-secret.yaml` — Secret for CloudNativePG/Postgres (apply manually)

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

- Point your ArgoCD Application at the `n8n-app/` directory
- Sync the application in ArgoCD

4. **Access n8n**

- Once deployed, access n8n via the configured ingress or service URL
- Initial login credentials are stored in `n8n-secret.yaml`

## Data Backup Considerations

1. **Database Backups**

   - Use CloudNativePG's built-in backup features
   - Configure regular backups through Longhorn
   - Consider implementing point-in-time recovery

2. **n8n Data Backups**
   - Use Longhorn's snapshot feature for the n8n-data PVC
   - Regular backups of the `.n8n` directory
   - Export important workflows through the UI

## Why this approach?

- **Secrets/config are not exposed in Git or managed by ArgoCD**
- **ArgoCD manages all other resources for GitOps and automation**
- **Easy to migrate to full GitOps/External Secrets in the future**
- **Reliable data persistence across pod restarts and node failures**
- **Secure credential storage and proper file permissions**
