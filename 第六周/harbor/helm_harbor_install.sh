# helm添加harbor chart仓库
root@master:~# helm repo add harbor https://helm.goharbor.io
root@master:~# helm repo list
NAME    URL
harbor  https://helm.goharbor.io

# helm更新chart仓库
root@master:~# helm repo update
root@master:~# helm search repo harbor
NAME            CHART VERSION   APP VERSION     DESCRIPTION
harbor/harbor   1.14.0          2.10.0          An open source trusted cloud native registry th...

# helm安装主barbor
root@master:~# helm install master-harbor \
               -f harbor-master-values.yaml harbor/harbor \
               -n harbor --create-namespace
root@master:~# helm list -n harbor
NAME            NAMESPACE       REVISION        UPDATED                                 STATUS          CHART           APP VERSION
master-harbor   harbor          1               2024-02-07 06:13:48.763797505 +0000 UTC deployed        harbor-1.14.0   2.10.0
