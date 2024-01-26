一、修改kube-proxy模式为strict arp
kubectl edit configmap -n kube-system kube-proxy
mode: "ipvs"
ipvs:
  strictARP: true

二、部署MetalLB
# kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.13.12/config/manifests/metallb-native.yaml
kubectl apply -f metallb-native.yaml
kubecttl get pods -n metalb-system
 
三、部署地址池
kubectl apply -f metalb-ipaddresspool.yaml
kubectl get ipaddresspool -n metallb-system

四、部署二层通告方法
kubectl apply -f metallb-l2advertisement.yaml
kubectl get l2advertisement -n metallb-system
