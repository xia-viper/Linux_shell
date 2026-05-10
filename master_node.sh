#!/bin/bash
# master-install.sh

set -e

echo "=== 1. 基础配置 ==="
swapoff -a
sed -i '/ swap / s/^/#/' /etc/fstab

cat > /etc/sysctl.d/k8s.conf <<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF
sysctl --system

modprobe overlay
modprobe br_netfilter

echo "=== 2. 安装 containerd ==="
yum install -y containerd.io
mkdir -p /etc/containerd
containerd config default > /etc/containerd/config.toml
sed -i 's/SystemdCgroup = false/SystemdCgroup = true/' /etc/containerd/config.toml
sed -i 's|registry.k8s.io/pause:3.9|registry.aliyuncs.com/google_containers/pause:3.9|g' /etc/containerd/config.toml
systemctl start containerd
systemctl enable containerd

ctr image pull registry.aliyuncs.com/google_containers/pause:3.9
ctr image tag registry.aliyuncs.com/google_containers/pause:3.9 registry.k8s.io/pause:3.9

echo "=== 3. 安装 Kubernetes ==="
cat > /etc/yum.repos.d/kubernetes.repo <<EOF
[kubernetes]
name=Kubernetes
baseurl=https://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64/
enabled=1
gpgcheck=0
EOF

yum install -y kubelet-1.28.2 kubeadm-1.28.2 kubectl-1.28.2
systemctl enable kubelet

echo "=== 4. 初始化 Master ==="
kubeadm init \
	--apiserver-advertise-address=192.168.56.110 \
	--image-repository=registry.aliyuncs.com/google_containers \
	--kubernetes-version=v1.28.2 \
	--pod-network-cidr=10.244.0.0/16 \
	--cri-socket=unix:///run/containerd/containerd.sock

mkdir -p $HOME/.kube
cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
chown $(id -u):$(id -g) $HOME/.kube/config

echo "=== 5. 安装网络插件 ==="
# 此处省略 Flannel 配置，参考第五部分

echo "=== 完成 ==="
kubectl get nodes
