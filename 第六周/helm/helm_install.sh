# # Helm二进制包网站: https://github.com/helm/helm/releases
# Chart仓库官网: https://artifacthub.io/

# 科学上网后下载Helm，主节点安装Helm
root@master:~# curl -LO https://get.helm.sh/helm-v3.14.0-linux-amd64.tar.gz
root@master:~# tar xf helm-v3.14.0-linux-amd64.tar.gz
root@master:~# cd linux-amd64/
root@master:~/linux-amd64# mv helm /usr/local/bin/
root@master:~/linux-amd64# helm --help