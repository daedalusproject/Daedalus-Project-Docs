# First Kubernetes approarch

Create namespaces

```bash
kubectl create namespace daedalus-project-docs-develop
kubectl create namespace daedalus-project-docs
```

## Development

### Create deployment
```bash
kubectl create -f develop/daedalus-project-docs-deplyment.yaml  -n daedalus-project-docs-develop
```

Check pods
```
k get pods -n daedalus-project-docs-develop
NAME                                             READY   STATUS    RESTARTS   AGE
daedalus-project-docs-develop-864b65d948-zccmd   1/1     Running   0          106s
```

### Create service
```bash
kubectl create -f develop/daedalus-project-docs-service.yaml  -n daedalus-project-docs-develop
```

### Ingress

```bash
kubectl create -f develop/ingress.yaml  -n daedalus-project-docs-develop
```

