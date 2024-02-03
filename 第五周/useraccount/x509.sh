主节点执行
# 创建存放证书和私钥的目录
root@master:~# mkdir certs
root@master:~# cd certs/

# 生成用户test3私钥
root@master:~/certs# openssl genrsa -out test3.key 2048

# 通过用户test3私钥生成证书签发请求, CN为用户名, O为用户所属组
root@master:~/certs# openssl req -new -key test3.key -out test3.csr -subj "/CN=test3/O=developers"

# kubernetes的CA签署用户test3发出的证书签发请求
root@master:~/certs# vim certificatesignrequest-test3.yaml
#################################################################################################
apiVersion: certificates.k8s.io/v1
kind: CertificateSigningRequest
metadata:
  name: test3
spec:
  # request字段的值，是csr文件内容base64编码后的结果
  # 用于生成编码的命令: cat test3.csr | base64 | tr -d "\n"
  request: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURSBSRVFVRVNULS0tLS0KTUlJQ2FqQ0NBVklDQVFBd0pURU9NQXdHQTFVRUF3d0ZkR1Z6ZERNeEV6QVJCZ05WQkFvTUNtUmxkbVZzYjNCbApjbk13Z2dFaU1BMEdDU3FHU0liM0RRRUJBUVVBQT
RJQkR3QXdnZ0VLQW9JQkFRRGlUS2phRXUzTWRyTW1XTWxlCkxmajZETkp4eXVJWUY1clZxbWlKK0xCMWpqVk9WZ0J2ZWRhZjErbW1hVktVc0M1R2IwRW9Tcklkc1JMdU5GMW4KSXBURVFOWlhKcUEzaXZuU1J1cXF6Sk1RTVNNRFlVNU03cFNKVU5
obU1DMWUxay9qUFQ2Z09nazNjM1p6U085RwpNcUFmelBKcnFueU13cFcybmhqTFd4OTJrRkZaWFJTSFgwNUlMTUVENUVtb3ZiOU5xcFJwZzdicVVyOGtvZk9zCkhhdHg2Um1nNzBSNWxCMjdnMUdVeDRjbWI0TFlKWFFOTmdyWFREZUIxZU0vUkNx
YjRsRjY1YXZ2dzZZYTVCWEMKekJNazhnclhTaVhiNHZ1a3ZRb1Z3S3ozTlN5bHRJeGp0eXJJZ043SCtCUzFDYXhVMll2bEg5a1krbWI3aHh2agozek9iQWdNQkFBR2dBREFOQmdrcWhraUc5dzBCQVFzRkFBT0NBUUVBcWxPNTZuOUxxTmprQ2R0a
GthNzVYT3BECmxaaldsMk5NeStIR3NuQ1daOEZsRlVpT01xcjZkdnZGUzcxUHB2MytwbXRreWpHZ2FzY0tsTWtJaWlORWxYdXIKczR3N0tYbkhWV1Mzb0FqK2NabkFDZmw2RndFZytFY3NNRlhlVEFtZFk0d292WjE4eC9YalVMbDQ1WW5GSXNzNQ
phSUZiSElKK29DTTQwNE14c1VqTFhxVTB2c1NRNE9tNkp1NXEwTHJzcUpMRDV6Rlk4dTdhVnFWVk9vdFBIWnhJCmFjLytiU2lhRmI4amY5ZHNNYk9RK2RTOXdyVEdRdXgwc1MzVmpRbFltYkhrVTdKMVJJd0Z5T0NxMVNTbHFYYmgKZEp3VUNYUVR
1VHQ0RU52Umh5bFlvU3R5YktmbXVpWFVIV0FJMEd3MEpHdjk1VVkyS01yMFRhcDdDeFhrQXc9PQotLS0tLUVORCBDRVJUSUZJQ0FURSBSRVFVRVNULS0tLS0K
  signerName: kubernetes.io/kube-apiserver-client
  expirationSeconds: 864000 # ten days
  usages:
   - client auth
#################################################################################################

# 创建CertificateSigningRequest资源
root@master:~/certs# kubectl apply -f certificatesignrequest-test3.yaml
root@master:~/certs# kubectl get csr
root@master:~/certs# kubectl get csr
NAME        AGE   SIGNERNAME                                    REQUESTOR                 REQUESTEDDURATION   CONDITION
test3       5s    kubernetes.io/kube-apiserver-client           kubernetes-admin          10d                 Pending
root@master:~/certs# kubectl certificate approve test3
root@master:~/certs# kubectl get csr
NAME        AGE   SIGNERNAME                                    REQUESTOR                 REQUESTEDDURATION   CONDITION
test3       61s   kubernetes.io/kube-apiserver-client           kubernetes-admin          10d                 Approved,Issued

# 保存用户test3证书
root@master:~/certs# kubectl get csr test3 -o jsonpath='{.status.certificate}' | base64 -d > test3.crt

# 用户test3访问认证测试
root@master:~/certs# curl -k -E ./test3.crt --key ./test3.key https://192.168.1.100:6443/api/v1/namespaces/default/pods/
{
  "kind": "Status",
  "apiVersion": "v1",
  "metadata": {},
  "status": "Failure",
  "message": "pods is forbidden: User \"test3\" cannot list resource \"pods\" in API group \"\" in the namespace \"default\"",
  "reason": "Forbidden",
  "details": {
    "kind": "pods"
  },
  "code": 403
}

# kubectl使用token访问API Server ---> 在没有kubeconfig配置文件的节点执行
root@node1:~# kubectl --server https://192.168.1.100:6443/ --client-certificate='/root/certs/test3.crt' --client-key='/root/certs/test3.key' --certificate-authority='/etc/kubernetes/pki/ca.crt' get pods
Error from server (Forbidden): pods is forbidden: User "test3" cannot list resource "pods" in API group "" in the namespace "default"

# 生成用户test4私钥
root@master:~/certs# openssl genrsa -out test4.key 2048

# 通过用户test4私钥生成证书签发请求, CN为用户名, O为用户所属组
root@master:~/certs# openssl req -new -key test4.key -out test4.csr -subj "/CN=test4/O=developers"

# 手动命令签署用户test4的证书创建请求
root@master:~/certs# openssl x509 -req -days 10 -CA /etc/kubernetes/pki/ca.crt -CAkey /etc/kubernetes/pki/ca.key -CAcreateserial -in ./test4.csr -out ./test4.crt
Certificate request self-signature ok
subject=CN = test4, O = developers

# 用户test4访问认证测试
root@master:~/certs# curl -k -E ./test4.crt --key ./test4.key https://192.168.1.100:6443/api/v1/namespaces/default/pods/
{
  "kind": "Status",
  "apiVersion": "v1",
  "metadata": {},
  "status": "Failure",
  "message": "pods is forbidden: User \"test4\" cannot list resource \"pods\" in API group \"\" in the namespace \"default\"",
  "reason": "Forbidden",
  "details": {
    "kind": "pods"
  },
  "code": 403
}

# kubectl使用token访问API Server ---> 在没有kubeconfig配置文件的节点执行
root@node1:~# kubectl --server https://192.168.1.100:6443/ --client-certificate='/root/certs/test4.crt' --client-key='/root/certs/test4.key' --certificate-authority='/etc/kubernetes/pki/ca.crt' get pods
Error from server (Forbidden): pods is forbidden: User "test4" cannot list resource "pods" in API group "" in the namespace "default"
