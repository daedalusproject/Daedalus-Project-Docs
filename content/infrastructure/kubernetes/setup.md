+++
title="Cluster setup"
weight = 511
+++

## Requirements

We need 4 machines running *Ubuntu 18.04* Server Edition. With 2CPU's and 2GB of RAM, this machines will be running inside KVM host. Those images are in the same network. Swap must be disabled.

All nodes use Daedalus Project [Repos](/architecture/repos/).

```
master01.k8s.windmaker.net
minion01.k8s.windmaker.net
minion02.k8s.windmaker.net
minion03.k8s.windmaker.net
```

## Install cluster.

### Install kubeadm

```
apt-get install docker-ce docker-ce-cli containerd.io kubelet kubeadm kubectl
```

```
sysctl net.bridge.bridge-nf-call-iptables=1
```

### Init cluster

In *master01* init the cluster:
```
kubeadm init --pod-network-cidr=10.244.0.0/16 --service-cidr=10.244.0.0/20
```

Output should be like this, run this command in all minions:
```
kubeadm join 10.X.Y.Z:6443 --token sometoken \
    --discovery-token-ca-cert-hash sha256:somesha
```

Copy admin credentials from */etc/kubernetes/admin.conf*

Install flannel:
```
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/a70459be0084506e4ec919aa1c114638878db11b/Documentation/kube-flannel.yml
```

Show your nodes:
```
k get nodes
NAME                         STATUS   ROLES    AGE   VERSION
master01.k8s.windmaker.net   Ready    master   14m   v1.14.1
minion01.k8s.windmaker.net   Ready    <none>   43s   v1.14.1
minion02.k8s.windmaker.net   Ready    <none>   39s   v1.14.1
minion03.k8s.windmaker.net   Ready    <none>   20s   v1.14.1
```

### Set roles

```
kubectl label node minion01.k8s.windmaker.net node-role.kubernetes.io/worker=worker
kubectl label node minion02.k8s.windmaker.net node-role.kubernetes.io/worker=worker
kubectl label node minion03.k8s.windmaker.net node-role.kubernetes.io/worker=worker
```

### Configure CoreDNS proxy

Make CoreDNS proxy public request over /etc/hosts:

```
kubectl edit cm coredns -n kube-system
```

Place the following line:
```
proxy . /etc/resolv.conf
```

Restart CoreDNS:
```
kubectl get pods -n kube-system -oname |grep coredns |xargs kubectl delete -n kube-system
```

### Install MetalLB

Create namespace:
```
kubectl create namespace metallb-system
```


Create metallb configmap:
```
apiVersion: v1
kind: ConfigMap
metadata:
  namespace: metallb-system
  name: config
data:
  config: |
    address-pools:
    - name: default
      protocol: layer2
      addresses:
      - Minion01IP
      - Minion02IP
      - Minion03IP
```

Deploy metallb
```
kubectl apply -f https://raw.githubusercontent.com/google/metallb/v0.7.3/manifests/metallb.yaml
```


### Install Metrics Server

Install [Kubernetes Metrics Server](https://github.com/kubernetes-incubator/metrics-server)

```
cd "$(mktemp -d)"
wget https://github.com/kubernetes-incubator/metrics-server/archive/v0.3.3.tar.gz
tar -xvf v0.3.3.tar.gz
cd metrics-server-0.3.3/
kubectl create -f deploy/1.8+/
```

Edit metrics server deployment.
```
- name: metrics-server
  image: k8s.gcr.io/metrics-server-amd64:v0.3.2
  command:
  - /metrics-server
  - --kubelet-insecure-tls
```

Check top:

```
k top nodes
NAME                         CPU(cores)   CPU%   MEMORY(bytes)   MEMORY%
master01.k8s.windmaker.net   130m         6%     713Mi           37%
minion01.k8s.windmaker.net   57m          2%     514Mi           27%
minion02.k8s.windmaker.net   63m          3%     463Mi           24%
minion03.k8s.windmaker.net   55m          2%     472Mi           24%
```

### Install Krew

Follow project [instructions](https://github.com/kubernetes-sigs/krew).

### Install Nginx Ingress Controller

```
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/mandatory.yaml
```

Create service:
```
apiVersion: v1
kind: Service
metadata:
  name: ingress-nginx
  namespace: ingress-nginx
  labels:
    app.kubernetes.io/name: ingress-nginx
    app.kubernetes.io/part-of: ingress-nginx
spec:
  type: LoadBalancer
  ports:
    - name: http
      port: 80
      targetPort: 80
      protocol: TCP
    - name: https
      port: 443
      targetPort: 443
      protocol: TCP
  selector:
    app.kubernetes.io/name: ingress-nginx
    app.kubernetes.io/part-of: ingress-nginx
```

#### Modify externalTrafficPolicy

Edit service:

```
kubectl -n ingress-nginx edit svc ingress-nginx
```

Set `externalTrafficPolicy` to `Local`



Install Krew plugin.
```
kubectl krew install ingress-nginx
```
