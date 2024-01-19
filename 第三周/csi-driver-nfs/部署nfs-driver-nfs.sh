一、以Pod形式部署NFS Server
kubectl apply -f nfs-server.yaml

二、安装NFS CSI Driver
kubectl apply -f csi-nfs-rbac.yaml
kubectl apply -f csi-nfs-controller.yaml
kubectl apply -f csi-nfs-driverinfo.yaml
kubectl apply -f csi-nfs-node.yaml