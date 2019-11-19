+++
title="Cluster setup"
weight = 511
+++

## Requirements

We need 6 machines running *Ubuntu 18.04* Server Edition. With 4CPU's and 4GB of RAM, this machines will be running inside KVM host. Those images are in the same network. Swap must be disabled.

All nodes use Daedalus Project [Repos](/architecture/repos/).

```
master01.k8s.windmaker.net
minion01.k8s.windmaker.net
minion02.k8s.windmaker.net
minion03.k8s.windmaker.net
minion04.k8s.windmaker.net
minion05.k8s.windmaker.net
```

## Install cluster.

### Prepare CRI-O prerequisites

In each machine run:
```
cat > /etc/modules-load.d/crio.conf <<EOF
overlay
br_netfilter
EOF

modprobe overlay
modprobe br_netfilter

# Setup required sysctl params, these persist across reboots.
cat > /etc/sysctl.conf <<EOF
net.bridge.bridge-nf-call-iptables  = 1
net.ipv4.ip_forward                 = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF

sysctl --system
```

### Install kubeadm

```
apt-get install cri-o-1.15 cri-tools kubelet kubeadm kubectl
mkdir -p /usr/local/libexec/crio/
ln -s /usr/bin/conmon /usr/libexec/crio/conmon
```

### Configure crio

Edit */etc/crio/crio.conf* and change cgroup_manager option from:
```
cgroup_manager = "systemd"
```

to:
```
cgroup_manager = "cgroupfs"
```

Enable also docker.io registry:
```
registries = [
  "docker.io",
]
```

Edit */etc/cni/net.d/100-crio-bridge.conf* and change IP range (for the same we are going to use in Kubernetes):
```
{
    "cniVersion": "0.3.1",
    "name": "crio-bridge",
    "type": "bridge",
    "bridge": "cni0",
    "isGateway": true,
    "ipMasq": true,
    "ipam": {
        "type": "host-local",
        "subnet": "10.244.0.0/16",
        "routes": [
            { "dst": "0.0.0.0/0" }
        ]
    }
}
```

```
systemctl enable crio
systemctl start crio
```

### Init cluster

In *master01*, initiate the cluster:
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
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
```

Show your nodes:
```
k get nodes
NAME                         STATUS   ROLES    AGE     VERSION
master01.k8s.windmaker.net   Ready    master   11m     v1.16.3
minion01.k8s.windmaker.net   Ready    <none>   7m50s   v1.16.3
minion02.k8s.windmaker.net   Ready    <none>   4m19s   v1.16.3
minion03.k8s.windmaker.net   Ready    <none>   2m56s   v1.16.3
minion04.k8s.windmaker.net   Ready    <none>   43s     v1.16.3
minion05.k8s.windmaker.net   Ready    <none>   15s     v1.16.3
```

### Set roles

```
kubectl label node minion01.k8s.windmaker.net node-role.kubernetes.io/worker=worker
kubectl label node minion02.k8s.windmaker.net node-role.kubernetes.io/worker=worker
kubectl label node minion03.k8s.windmaker.net node-role.kubernetes.io/worker=worker
kubectl label node minion04.k8s.windmaker.net node-role.kubernetes.io/worker=worker
kubectl label node minion05.k8s.windmaker.net node-role.kubernetes.io/worker=worker
```

### Install MetalLB

Create namespace:
```
kubectl create namespace metallb-system
```


Create metallb configmap:
```
kubectl -n metallb-system create configmap config
kubectl -n metallb-system edit configmap config
```

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
      - Minion01IP-Minion03IP (for example 10.10.0.100-10.10.0.103)
```

Deploy metallb
```
kubectl apply -f https://raw.githubusercontent.com/google/metallb/v0.8.3/manifests/metallb.yaml
```


### Install Metrics Server

Install [Kubernetes Metrics Server](https://github.com/kubernetes-incubator/metrics-server)

```
cd "$(mktemp -d)"
wget https://github.com/kubernetes-incubator/metrics-server/archive/v0.3.6.tar.gz
tar -xvf v0.3.6.tar.gz
cd metrics-server-0.3.6/
kubectl create -f deploy/1.8+/
```

Edit metrics server deployment.
```
- name: metrics-server
  image: k8s.gcr.io/metrics-server-amd64:v0.3.2
  command:
  - /metrics-server
  - --kubelet-insecure-tls
  - --kubelet-preferred-address-types=InternalIP
```

Check top:

```
k top nodes
NAME                         CPU(cores)   CPU%   MEMORY(bytes)   MEMORY%
master01.k8s.windmaker.net   129m         3%     550Mi           14%
minion01.k8s.windmaker.net   39m          0%     285Mi           7%
minion02.k8s.windmaker.net   32m          0%     243Mi           6%
minion03.k8s.windmaker.net   37m          0%     258Mi           6%
minion04.k8s.windmaker.net   58m          1%     253Mi           6%
minion05.k8s.windmaker.net   65m          1%     251Mi           6%
```

### Install Nginx Ingress Controller

```
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/static/mandatory.yaml
```

Create the following service:
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

