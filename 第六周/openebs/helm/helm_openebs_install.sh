# k8s所有节点部署iSCSI client
apt-get update
apt-get install open-iscsi
systemctl enable --now iscsid

# k8s所有节点安装nfs-common
apt-get update
apt-get install nfs-common

# helm添加openebs chart仓库
root@master:~# helm repo add openebs https://openebs.github.io/charts
root@master:~# helm repo update
root@master:~# helm repo list
NAME    URL
openebs https://openebs.github.io/charts

# helm安装含有jiva和nfs-provisioner插件的openebs
root@master:~# helm install openebs \
			   openebs/openebs \
			   --set jiva.enabled=true \
			   --set jiva.replicas=2 \
			   --set nfs-provisioner.enabled=true \
			   --namespace openebs \
			   --create-namespace
root@master:~# helm list -n openebs
NAME    NAMESPACE       REVISION        UPDATED                                 STATUS          CHART           APP VERSION
openebs openebs         1               2024-02-07 08:59:18.798403667 +0000 UTC deployed        openebs-3.10.0  3.10.0

# 解决国外(registry.k8s.io)镜像下载不了的问题
root@master:~# helm get manifest openebs -n openebs > openebs.yaml
修改openebs.yaml文件, 把image国外镜像地址全部改成国内镜像地址
root@master:~# helm delete openebs -n openebs
root@master:~# kubectl apply -f openebs.yaml -n openebs

# 创建nfs存储类
root@master:~# kubectl apply -f nfs-sotrageclass.yaml

# 查看安装的openebs
root@master:~# kubectl get pods -n openebs
NAME                                           READY   STATUS    RESTARTS   AGE
openebs-jiva-csi-controller-0                  5/5     Running   0          4m
openebs-jiva-csi-node-gtjs2                    3/3     Running   0          4m
openebs-jiva-csi-node-h82pc                    3/3     Running   0          4m
openebs-jiva-csi-node-k42d7                    3/3     Running   0          4m
openebs-jiva-operator-69bd68fccc-mvtnw         1/1     Running   0          4m
openebs-localpv-provisioner-56d6489bbc-nw8gh   1/1     Running   0          4m
openebs-ndm-b265g                              1/1     Running   0          4m
openebs-ndm-gxp9s                              1/1     Running   0          4m
openebs-ndm-n5d9j                              1/1     Running   0          4m
openebs-ndm-operator-5d7944c94d-5wshp          1/1     Running   0          4m
openebs-nfs-provisioner-5568976b7-c77ld        1/1     Running   0          4m
root@master:~# kubectl get sc
NAME                       PROVISIONER           RECLAIMPOLICY   VOLUMEBINDINGMODE      ALLOWVOLUMEEXPANSION   AGE
openebs-device             openebs.io/local      Delete          WaitForFirstConsumer   false                  59m
openebs-hostpath           openebs.io/local      Delete          WaitForFirstConsumer   false                  59m
openebs-jiva-csi-default   jiva.csi.openebs.io   Delete          Immediate              true                   59m
openebs-kernel-nfs         openebs.io/nfsrwx     Delete          Immediate              false                  59m
openebs-rwx                openebs.io/nfsrwx     Delete          Immediate              false                  34s
