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
root@master:~# kubectl get pods -n blog
NAME                         READY   STATUS    RESTARTS   AGE
mysql-primary-0              1/1     Running   0          151m
mysql-secondary-0            1/1     Running   0          151m
wordpress-784d474ff5-dxj84   1/1     Running   0          11m
root@master:~# kubectl get svc -n blog
NAME                       TYPE           CLUSTER-IP       EXTERNAL-IP     PORT(S)                      AGE
mysql-primary              ClusterIP      10.99.73.197     <none>          3306/TCP                     151m
mysql-primary-headless     ClusterIP      None             <none>          3306/TCP                     151m
mysql-secondary            ClusterIP      10.110.104.161   <none>          3306/TCP                     151m
mysql-secondary-headless   ClusterIP      None             <none>          3306/TCP                     151m
wordpress                  LoadBalancer   10.109.28.4      192.168.1.141   80:32392/TCP,443:31630/TCP   12m
root@master:~# kubectl get ingresses -n blog
NAME        CLASS   HOSTS              ADDRESS         PORTS   AGE
wordpress   nginx   blog.example.com   192.168.1.140   80      12m
