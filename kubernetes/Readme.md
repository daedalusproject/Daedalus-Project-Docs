# Kubernetes

This project is deployed over Windmaker's Kubernetes cluster.

## Prerequisites

As cluster admin you should create namespaces and specific service account to operate over those namespaces.

```bash
kubectl apply -f setup.yaml
```

Gitlab CI/CD needs gitlab-daedalus-project-docs-deployer:
```
kubectl -n daedalus-project-docs describe secrets $(kubectl -n daedalus-project-docs get secret | grep gitlab-daedalus-project-docs-deployer | awk  '{print $1}') | grep token: | awk  '{print $2}'
```

Three namespaces will be created:

* daedalus-project-docs-develop
* daedalus-project-docs-staging
* daedalus-project-docs

Service account *gitlab-daedalus-project-docs-deployer* is able to create and update resources in all these namespaces.

## Environments

There are three environments, one for each namespace:

### Development

Available at [dev-docs.daedalus-project.io](https://dev-docs.daedalus-project.io/).

Deployed after each *develop* update.

### Staging

Available at [staging-docs.daedalus-project.io](https://staging-docs.daedalus-project.io/).

Deployed after each *master* update.

### Production

Available at [docs.daedalus-project.io](https://docs.daedalus-project.io/).

Deployed with each tag.

## Manifests

Each environments uses the same manifest names, configurations differ.
```bash
.
├── develop
│   ├── daedalus-project-docs-deplyment.yaml
│   ├── daedalus-project-docs-service.yaml
│   └── ingress.yaml
```

### SSL certs.

Ingress used by Daedalus Projects is [NGINX Ingress Controller ](https://kubernetes.github.io/ingress-nginx/deploy/)

For the time being SSL certificates are not provided automatically.

For each namespace.
```bash
kubectl create secret tls daedalus-project-docs-develop-cert --key daedalus-project.io.key --cert daedalus-project.io.pem  -n daedalus-project-docs-develop
kubectl create secret tls daedalus-project-docs-staging-cert --key daedalus-project.io.key --cert daedalus-project.io.pem  -n daedalus-project-docs-staging
kubectl create secret tls daedalus-project-docs-cert --key daedalus-project.io.key --cert daedalus-project.io.pem  -n daedalus-project-docs
```
