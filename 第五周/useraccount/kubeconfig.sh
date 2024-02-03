主节点执行
# 创建存放kubeconfig文件目录
root@master:~# mkdir /root/hxd -p

# 创建集群并在/root/hxd目录下生成kubeconfig文件
root@master:~# kubectl config set-cluster mycluster --server=https://192.168.1.100:6443 --certificate-authority='/etc/kubernetes/pki/ca.crt' --embed-certs=true --kubeconfig='/root/hxd/kcf1'
root@master:~# kubectl config set-cluster mycluster --server=https://192.168.1.100:6443 --certificate-authority='/etc/kubernetes/pki/ca.crt' --embed-certs=true --kubeconfig='/root/hxd/kcf2'

# 为test1、test2、test3、test4用户创建凭证
root@master:~# kubectl config set-credentials test1 --token='9e49fd.13f6c7cd0d91784e' --kubeconfig='/root/hxd/kcf1'
root@master:~# kubectl config set-credentials test2 --token='67fcfe.4e73377262622882' --kubeconfig='/root/hxd/kcf1'
root@master:~# kubectl config set-credentials test3 --client-certificate='/root/certs/test3.crt' --client-key='/root/certs/test3.key' --embed-certs=true --kubeconfig='/root/hxd/kcf2'
root@master:~# kubectl config set-credentials test4 --client-certificate='/root/certs/test4.crt' --client-key='/root/certs/test4.key' --embed-certs=true --kubeconfig='/root/hxd/kcf2'

# 创建test1、test2、test3、test4用户访问集群的上下文
root@master:~# kubectl config set-context test1@mycluster --cluster=mycluster --user=test1 --kubeconfig='/root/hxd/kcf1'
root@master:~# kubectl config set-context test2@mycluster --cluster=mycluster --user=test2 --kubeconfig='/root/hxd/kcf1'
root@master:~# kubectl config set-context test3@mycluster --cluster=mycluster --user=test3 --kubeconfig='/root/hxd/kcf2'
root@master:~# kubectl config set-context test4@mycluster --cluster=mycluster --user=test4 --kubeconfig='/root/hxd/kcf2'

# 设置test1、test2、test3、test4用户访问集群的默认上下文
root@master:~# kubectl config use-context test1@mycluster --kubeconfig='/root/hxd/kcf1'
root@master:~# kubectl config use-context test3@mycluster --kubeconfig='/root/hxd/kcf2'

# 查看kcf1和kcf2的内容
root@master:~# kubectl config view --kubeconfig='/root/hxd/kcf1'
apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: DATA+OMITTED
    server: https://192.168.1.100:6443
  name: mycluster
contexts:
- context:
    cluster: mycluster
    user: test1
  name: test1@mycluster
- context:
    cluster: mycluster
    user: test2
  name: test2@mycluster
current-context: test1@mycluster
kind: Config
preferences: {}
users:
- name: test1
  user:
    token: REDACTED
- name: test2
  user:
    token: REDACTED
root@master:~# kubectl config view --kubeconfig='/root/hxd/kcf2'
apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: DATA+OMITTED
    server: https://192.168.1.100:6443
  name: mycluster
contexts:
- context:
    cluster: mycluster
    user: test3
  name: test3@mycluster
- context:
    cluster: mycluster
    user: test4
  name: test4@mycluster
current-context: test3@mycluster
kind: Config
preferences: {}
users:
- name: test3
  user:
    client-certificate-data: DATA+OMITTED
    client-key-data: DATA+OMITTED
- name: test4
  user:
    client-certificate-data: DATA+OMITTED
    client-key-data: DATA+OMITTED

# 查看kubeconfig上下文
root@master:~# kubectl config get-contexts --kubeconfig='/root/hxd/kcf1'
CURRENT   NAME              CLUSTER     AUTHINFO   NAMESPACE
*         test1@mycluster   mycluster   test1
          test2@mycluster   mycluster   test2
root@master:~# kubectl config get-contexts --kubeconfig='/root/hxd/kcf2'
CURRENT   NAME              CLUSTER     AUTHINFO   NAMESPACE
*         test3@mycluster   mycluster   test3
          test4@mycluster   mycluster   test4

# kubectl使用kubeconfig访问集群测试
root@master:~# kubectl get pods --kubeconfig='/root/hxd/kcf1'
Error from server (Forbidden): pods is forbidden: User "test1" cannot list resource "pods" in API group "" in the namespace "default"

root@master:~# kubectl get pods --kubeconfig='/root/hxd/kcf1' --context='test2@mycluster'
Error from server (Forbidden): pods is forbidden: User "test2" cannot list resource "pods" in API group "" in the namespace "default"

root@master:~# kubectl get pods --kubeconfig='/root/hxd/kcf2'
Error from server (Forbidden): pods is forbidden: User "test3" cannot list resource "pods" in API group "" in the namespace "default"

root@master:~# kubectl get pods --kubeconfig='/root/hxd/kcf2' --context='test4@mycluster'
Error from server (Forbidden): pods is forbidden: User "test4" cannot list resource "pods" in API group "" in the namespace "default"

# 合并kubeconfig文件
root@master:~# export KUBECONFIG='/root/hxd/kcf1:/root/hxd/kcf2'
root@master:~# kubectl config view
apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: DATA+OMITTED
    server: https://192.168.1.100:6443
  name: mycluster
contexts:
- context:
    cluster: mycluster
    user: test1
  name: test1@mycluster
- context:
    cluster: mycluster
    user: test2
  name: test2@mycluster
- context:
    cluster: mycluster
    user: test3
  name: test3@mycluster
- context:
    cluster: mycluster
    user: test4
  name: test4@mycluster
current-context: test1@mycluster
kind: Config
preferences: {}
users:
- name: test1
  user:
    token: REDACTED
- name: test2
  user:
    token: REDACTED
- name: test3
  user:
    client-certificate-data: DATA+OMITTED
    client-key-data: DATA+OMITTED
- name: test4
  user:
    client-certificate-data: DATA+OMITTED
    client-key-data: DATA+OMITTED
