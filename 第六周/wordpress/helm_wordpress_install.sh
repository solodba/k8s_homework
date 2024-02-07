# k8s所有节点安装nfs-common
root@master:~# apt update
root@master:~# apt install -y nfs-common

# helm部署wordpress服务
root@master:~# helm install wordpress \
               oci://registry-1.docker.io/bitnamicharts/wordpress \
               -f wordpress-values.yaml \
               -n blog --create-namespace
root@master:~# helm list -n blog
NAME            NAMESPACE       REVISION        UPDATED                                 STATUS          CHART                   APP VERSION
mysql           blog            1               2024-02-07 03:09:50.609364819 +0000 UTC deployed        mysql-9.19.1            8.0.36
wordpress       blog            1               2024-02-07 04:08:46.524188345 +0000 UTC deployed        wordpress-19.2.3        6.4.3
