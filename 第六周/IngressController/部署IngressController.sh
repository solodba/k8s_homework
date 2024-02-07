# 官方社区网站: https://github.com/kubernetes/ingress-nginx
# 官方文档地址: https://kubernetes.github.io/ingress-nginx/deploy/

# 准备科学上网, 为了拉取镜像, k8s所有节点进行配置, 使用"registry.cn-hangzhou.aliyuncs.com/google_containers"国内阿里云镜像地址也不能下载
# 也可以不用科学上网, 镜像换成DockerHub上"dyrnq/controller:v1.9.6"和"dyrnq/kube-webhook-certgen:v20231226-1a7112e06"
vim /usr/lib/systemd/system/containerd.service
################################################################################################################
# 在Service模块下添加如下内容
[Service]
Environment="HTTP_PROXY=http://192.168.1.3:7890"
Environment="HTTPS_PROXY=https://192.168.1.3:7890"
Environment="NO_PROXY=127.0.0.0/8,172.17.0.0/16,172.29.0.0/16,10.244.0.0/16,192.168.0.0/16,10.0.0.0/8,magedu.com,cluster.local"
################################################################################################################
systemctl daemon-reload && systemctl restart containerd.service

# 部署IngressController --- 主节点执行
#kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.9.6/deploy/static/provider/cloud/deploy.yaml
kubectl apply -f IngressController-v1.9.6.yaml
kubectl get ns
kubectl get pods -n ingress-nginx
kubectl get svc -n ingress-nginx
