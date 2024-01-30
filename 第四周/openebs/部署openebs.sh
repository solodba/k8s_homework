部署文档 https://openebs.io/docs/user-guides/installation

一、部署OpenEBS基础环境
OpenEBS的基础部署会创建两个StorageClass
openebs-hostpath: 基于hostpath动态置备Local PV
openebs-device: 基于NDM管理的device动态置备Local PV

# kubectl apply -f https://openebs.github.io/charts/openebs-operator.yaml
kubectl apply -f openebs-operator.yaml
kubectl get pods -n openebs
kubectl get storageclass

二、若需要支持Jiva、cStor、Local PV ZFS和Loal PV LVM等存储引擎,还需要额外部署相关的组件
例如,部署Jiva CSI
# 每个节点部署iSCSI client, 以Ubuntu为例
apt-get update
apt-get install open-iscsi
systemctl enable --now iscsid

# 部署jiva operator
# kubectl apply -f https://openebs.github.io/charts/jiva-operator.yaml
kubectl apply -f jiva-operator.yaml

三、部署支持多路读写的NFS服务,内置有创建存储类,可以关联jiva
kubectl apply -f nfs-operator.yaml
