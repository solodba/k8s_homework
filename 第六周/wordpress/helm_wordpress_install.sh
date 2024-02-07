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
root@master:~# kubectl get pvc -n blog
NAME                     STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS       VOLUMEATTRIBUTESCLASS   AGE
data-mysql-primary-0     Bound    pvc-7b064c7e-9497-48c4-89ab-a11b20263a08   8Gi        RWO            openebs-hostpath   <unset>                 153m
data-mysql-secondary-0   Bound    pvc-62934d48-bd4b-42df-abbb-efb6cfdb8d88   8Gi        RWO            openebs-hostpath   <unset>                 153m
wordpress                Bound    pvc-a1c189bd-f1a0-4a50-9e0c-d83013896bd4   10Gi       RWX            openebs-rwx        <unset>                 13m
root@master:~# kubectl get pv
NAME                                       CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM                                                  STORAGECLASS       VOLUMEATTRIBUTESCLASS   REASON   AGE
pvc-0d3ec3f0-9a4f-4bab-8b9e-30061cea3cda   10Gi       RWO            Delete           Bound    openebs/nfs-pvc-a1c189bd-f1a0-4a50-9e0c-d83013896bd4   openebs-hostpath   <unset>                          13m
pvc-62934d48-bd4b-42df-abbb-efb6cfdb8d88   8Gi        RWO            Delete           Bound    blog/data-mysql-secondary-0                            openebs-hostpath   <unset>                          153m
pvc-7b064c7e-9497-48c4-89ab-a11b20263a08   8Gi        RWO            Delete           Bound    blog/data-mysql-primary-0                              openebs-hostpath   <unset>                          153m
pvc-a1c189bd-f1a0-4a50-9e0c-d83013896bd4   10Gi       RWX            Delete           Bound    blog/wordpress                                         openebs-rwx        <unset>                          13m
