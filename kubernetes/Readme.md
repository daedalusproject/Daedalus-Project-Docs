Create a namespace

```bash
kubectl create namespace daedalus-project-docs-develop
```

Create deployment
```bash
kubectl create -f daedalus-project-docs-deplyment.yaml  -n daedalus-project-docs-develop
```

Check pods
```
k get pods -n daedalus-project-docs-develop
NAME                                             READY   STATUS    RESTARTS   AGE
daedalus-project-docs-develop-864b65d948-zccmd   1/1     Running   0          106s
```
