# k8s所有节点安装nfs-common
root@master:~# apt update
root@master:~# apt install -y nfs-common

# helm部署wordpress服务
root@master:~# helm install wordpress \
               oci://registry-1.docker.io/bitnamicharts/wordpress \
               -f wordpress-values.yaml \
               -n blog --create-namespace
