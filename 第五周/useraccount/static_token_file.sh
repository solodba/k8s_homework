主节点执行
# 为test1、test2、test3用户手动生成token
root@master:~# echo "$(openssl rand -hex 3).$(openssl rand -hex 8)"
9e49fd.13f6c7cd0d91784e
root@master:~# echo "$(openssl rand -hex 3).$(openssl rand -hex 8)"
67fcfe.4e73377262622882

# 创建存放用户信息的csv文件
root@master:~# mkdir /etc/kubernetes/authfiles
root@master:~# vim /etc/kubernetes/authfiles/tokens.csv
###################################################################
9e49fd.13f6c7cd0d91784e,test1,3001,kubeusers
67fcfe.4e73377262622882,test2,3002,kubeusers
###################################################################

# 修改kube-apiserver.yaml文件，加载token-auth-file
root@master:~# cp /etc/kubernetes/manifests/kube-apiserver.yaml ./
root@master:~# vim kube-apiserver.yaml
###################################################################
# 添加卷
- hostPath:
    path: /etc/kubernetes/authfiles/tokens.csv
    type: FileOrCreate
  name: static-tokens-file
# 添加挂载点
- mountPath: /etc/kubernetes/authfiles/tokens.csv
  name: static-tokens-file
  readOnly: true
# 添加加载命令选项
- command:
    - --token-auth-file=/etc/kubernetes/authfiles/tokens.csv
####################################################################

# 重新加载新的kube-apiserver.yaml文件
root@master:~# cp /etc/kubernetes/manifests/kube-apiserver.yaml /tmp/
root@master:~# cp kube-apiserver.yaml /etc/kubernetes/manifests/kube-apiserver.yaml

# 用户访问认证测试
root@master:~# curl -k -H "Authorization: Bearer 9e49fd.13f6c7cd0d91784e" -k https://192.168.1.100:6443/api/v1/namespaces/default/pods/
{
  "kind": "Status",
  "apiVersion": "v1",
  "metadata": {},
  "status": "Failure",
  "message": "pods is forbidden: User \"test1\" cannot list resource \"pods\" in API group \"\" in the namespace \"default\"",
  "reason": "Forbidden",
  "details": {
    "kind": "pods"
  },
  "code": 403
}
root@master:~# curl -k -H "Authorization: Bearer 67fcfe.4e73377262622882" -k https://192.168.1.100:6443/api/v1/namespaces/default/pods/
{
  "kind": "Status",
  "apiVersion": "v1",
  "metadata": {},
  "status": "Failure",
  "message": "pods is forbidden: User \"test2\" cannot list resource \"pods\" in API group \"\" in the namespace \"default\"",
  "reason": "Forbidden",
  "details": {
    "kind": "pods"
  },
  "code": 403
}
