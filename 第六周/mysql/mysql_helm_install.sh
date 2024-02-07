# helm部署mysql主从服务
root@master:~# helm search repo mysql
root@master:~# helm search hub mysql
root@master:~# helm install mysql \
               oci://registry-1.docker.io/bitnamicharts/mysql \
               -f mysql-values.yaml \
               -n blog --create-namespace
root@master:~# helm list -n blog
NAME    NAMESPACE       REVISION        UPDATED                                 STATUS          CHART           APP VERSION
mysql   blog            1               2024-02-07 03:09:50.609364819 +0000 UTC deployed        mysql-9.19.1    8.0.36
root@master:~# kubectl get pods -n blog
NAME                READY   STATUS    RESTARTS   AGE
mysql-primary-0     1/1     Running   0          57s
mysql-secondary-0   1/1     Running   0          57s
root@master:~# kubectl get pvc -n blog
NAME                     STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS       VOLUMEATTRIBUTESCLASS   AGE
data-mysql-primary-0     Bound    pvc-7b064c7e-9497-48c4-89ab-a11b20263a08   8Gi        RWO            openebs-hostpath   <unset>                 62s
data-mysql-secondary-0   Bound    pvc-62934d48-bd4b-42df-abbb-efb6cfdb8d88   8Gi        RWO            openebs-hostpath   <unset>                 62s
root@master:~# kubectl get pv
NAME                                       CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM                         STORAGECLASS       VOLUMEATTRIBUTESCLASS   REASON   AGE
pvc-62934d48-bd4b-42df-abbb-efb6cfdb8d88   8Gi        RWO            Delete           Bound    blog/data-mysql-secondary-0   openebs-hostpath   <unset>                          63s
pvc-7b064c7e-9497-48c4-89ab-a11b20263a08   8Gi        RWO            Delete           Bound    blog/data-mysql-primary-0     openebs-hostpath   <unset>                          64s
