# helm添加harbor chart仓库
root@master:~# helm repo add harbor https://helm.goharbor.io
root@master:~# helm repo list
NAME    URL
harbor  https://helm.goharbor.io

# helm更新chart仓库
root@master:~# helm repo update
root@master:~# helm search repo harbor
NAME            CHART VERSION   APP VERSION     DESCRIPTION
harbor/harbor   1.14.0          2.10.0          An open source trusted cloud native registry th...

# helm安装主barbor
root@master:~# helm install master-harbor \
               -f harbor-master-values.yaml harbor/harbor \
               -n harbor --create-namespace

# helm安装从barbor
root@master:~# helm install slave-harbor \
               -f harbor-slave-values.yaml harbor/harbor \
               -n harbor --create-namespace

# 查看安装的信息
root@master:~# helm list -n harbor
NAME            NAMESPACE       REVISION        UPDATED                                 STATUS          CHART           APP VERSION
master-harbor   harbor          1               2024-02-07 06:13:48.763797505 +0000 UTC deployed        harbor-1.14.0   2.10.0
slave-harbor    harbor          1               2024-02-07 06:23:43.72311734 +0000 UTC  deployed        harbor-1.14.0   2.10.0
root@master:~# kubectl get pods -n harbor -o wide
NAME                                        READY   STATUS    RESTARTS        AGE    IP            NODE    NOMINATED NODE   READINESS GATES
master-harbor-core-7b94689b79-d6wsm         1/1     Running   2 (5m45s ago)   11m    10.244.1.31   node3   <none>           <none>
master-harbor-database-0                    1/1     Running   0               11m    10.244.2.48   node2   <none>           <none>
master-harbor-jobservice-78f685ccd8-dkbph   1/1     Running   0               4m8s   10.244.3.26   node1   <none>           <none>
master-harbor-portal-6f4d9f4566-qkbc4       1/1     Running   0               11m    10.244.2.44   node2   <none>           <none>
master-harbor-redis-0                       1/1     Running   0               11m    10.244.3.25   node1   <none>           <none>
master-harbor-registry-9f59c757f-f5rh5      2/2     Running   0               11m    10.244.2.47   node2   <none>           <none>
master-harbor-trivy-0                       1/1     Running   0               11m    10.244.1.33   node3   <none>           <none>
slave-harbor-core-6f74fcd888-mhnpk          1/1     Running   0               75s    10.244.3.28   node1   <none>           <none>
slave-harbor-database-0                     1/1     Running   0               75s    10.244.1.35   node3   <none>           <none>
slave-harbor-jobservice-b9fdd78cc-wz7pf     1/1     Running   2 (70s ago)     75s    10.244.3.29   node1   <none>           <none>
slave-harbor-portal-6b69c7f499-729pj        1/1     Running   0               75s    10.244.2.51   node2   <none>           <none>
slave-harbor-redis-0                        1/1     Running   0               75s    10.244.3.31   node1   <none>           <none>
slave-harbor-registry-65d4dfd6b7-4zrzj      2/2     Running   0               75s    10.244.2.52   node2   <none>           <none>
slave-harbor-trivy-0                        1/1     Running   0               75s    10.244.2.53   node2   <none>           <none>
root@master:~# kubectl get svc -n harbor
NAME                       TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)             AGE
master-harbor-core         ClusterIP   10.108.2.0       <none>        80/TCP              11m
master-harbor-database     ClusterIP   10.107.123.110   <none>        5432/TCP            11m
master-harbor-jobservice   ClusterIP   10.111.33.147    <none>        80/TCP              11m
master-harbor-portal       ClusterIP   10.105.80.74     <none>        80/TCP              11m
master-harbor-redis        ClusterIP   10.96.117.107    <none>        6379/TCP            11m
master-harbor-registry     ClusterIP   10.110.131.131   <none>        5000/TCP,8080/TCP   11m
master-harbor-trivy        ClusterIP   10.102.118.80    <none>        8080/TCP            11m
slave-harbor-core          ClusterIP   10.97.23.33      <none>        80/TCP              84s
slave-harbor-database      ClusterIP   10.97.48.181     <none>        5432/TCP            84s
slave-harbor-jobservice    ClusterIP   10.106.102.168   <none>        80/TCP              84s
slave-harbor-portal        ClusterIP   10.111.64.206    <none>        80/TCP              84s
slave-harbor-redis         ClusterIP   10.103.57.18     <none>        6379/TCP            84s
slave-harbor-registry      ClusterIP   10.101.219.9     <none>        5000/TCP,8080/TCP   84s
slave-harbor-trivy         ClusterIP   10.111.141.10    <none>        8080/TCP            84s
root@master:~# kubectl get pvc -n harbor
NAME                                     STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS       VOLUMEATTRIBUTESCLASS   AGE
data-master-harbor-redis-0               Bound    pvc-943f3fd5-bd9f-42f7-9901-52867178854a   2Gi        RWO            openebs-hostpath   <unset>                 11m
data-master-harbor-trivy-0               Bound    pvc-4e67486e-3bef-49ad-ba91-fe3aca91445e   5Gi        RWO            openebs-hostpath   <unset>                 11m
data-slave-harbor-redis-0                Bound    pvc-844d47f6-f25d-4e02-9360-4735774b1494   2Gi        RWO            openebs-hostpath   <unset>                 100s
data-slave-harbor-trivy-0                Bound    pvc-befbcf57-b9ba-4ef7-a8a3-0e9ad139f107   5Gi        RWO            openebs-hostpath   <unset>                 100s
database-data-master-harbor-database-0   Bound    pvc-a03aba7f-e743-47a7-96ae-fc220bc080fb   2Gi        RWO            openebs-hostpath   <unset>                 11m
database-data-slave-harbor-database-0    Bound    pvc-1b85bd20-cdf3-4fb2-8d8f-55bf487738bd   2Gi        RWO            openebs-hostpath   <unset>                 100s
master-harbor-jobservice                 Bound    pvc-de0a08b0-1337-45fc-8ed3-afd805d90408   1Gi        RWO            openebs-hostpath   <unset>                 11m
master-harbor-registry                   Bound    pvc-c2779ef3-8871-49ea-b48f-afb8d73d0ba1   5Gi        RWO            openebs-hostpath   <unset>                 11m
slave-harbor-jobservice                  Bound    pvc-8a6c3df2-4bb5-4653-bcc9-db6dcf7f0f18   1Gi        RWO            openebs-hostpath   <unset>                 100s
slave-harbor-registry                    Bound    pvc-3df33b5e-9512-442a-ae28-f37332b07978   5Gi        RWO            openebs-hostpath   <unset>                 100s
root@master:~# kubectl get pv
NAME                                       CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM                                                  STORAGECLASS       VOLUMEATTRIBUTESCLASS   REASON   AGE
pvc-0d3ec3f0-9a4f-4bab-8b9e-30061cea3cda   10Gi       RWO            Delete           Bound    openebs/nfs-pvc-a1c189bd-f1a0-4a50-9e0c-d83013896bd4   openebs-hostpath   <unset>                          55m
pvc-1b85bd20-cdf3-4fb2-8d8f-55bf487738bd   2Gi        RWO            Delete           Bound    harbor/database-data-slave-harbor-database-0           openebs-hostpath   <unset>                          101s
pvc-3df33b5e-9512-442a-ae28-f37332b07978   5Gi        RWO            Delete           Bound    harbor/slave-harbor-registry                           openebs-hostpath   <unset>                          102s
pvc-4e67486e-3bef-49ad-ba91-fe3aca91445e   5Gi        RWO            Delete           Bound    harbor/data-master-harbor-trivy-0                      openebs-hostpath   <unset>                          11m
pvc-62934d48-bd4b-42df-abbb-efb6cfdb8d88   8Gi        RWO            Delete           Bound    blog/data-mysql-secondary-0                            openebs-hostpath   <unset>                          3h15m
pvc-7b064c7e-9497-48c4-89ab-a11b20263a08   8Gi        RWO            Delete           Bound    blog/data-mysql-primary-0                              openebs-hostpath   <unset>                          3h15m
pvc-844d47f6-f25d-4e02-9360-4735774b1494   2Gi        RWO            Delete           Bound    harbor/data-slave-harbor-redis-0                       openebs-hostpath   <unset>                          100s
pvc-8a6c3df2-4bb5-4653-bcc9-db6dcf7f0f18   1Gi        RWO            Delete           Bound    harbor/slave-harbor-jobservice                         openebs-hostpath   <unset>                          104s
pvc-943f3fd5-bd9f-42f7-9901-52867178854a   2Gi        RWO            Delete           Bound    harbor/data-master-harbor-redis-0                      openebs-hostpath   <unset>                          11m
pvc-a03aba7f-e743-47a7-96ae-fc220bc080fb   2Gi        RWO            Delete           Bound    harbor/database-data-master-harbor-database-0          openebs-hostpath   <unset>                          11m
pvc-a1c189bd-f1a0-4a50-9e0c-d83013896bd4   10Gi       RWX            Delete           Bound    blog/wordpress                                         openebs-rwx        <unset>                          55m
pvc-befbcf57-b9ba-4ef7-a8a3-0e9ad139f107   5Gi        RWO            Delete           Bound    harbor/data-slave-harbor-trivy-0                       openebs-hostpath   <unset>                          101s
pvc-c2779ef3-8871-49ea-b48f-afb8d73d0ba1   5Gi        RWO            Delete           Bound    harbor/master-harbor-registry                          openebs-hostpath   <unset>                          11m
pvc-de0a08b0-1337-45fc-8ed3-afd805d90408   1Gi        RWO            Delete           Bound    harbor/master-harbor-jobservice                        openebs-hostpath   <unset>                          11m
root@master:~# kubectl get ingresses -n harbor
NAME                    CLASS    HOSTS                           ADDRESS         PORTS     AGE
master-harbor-ingress   <none>   registry.master.codehorse.com   192.168.1.140   80, 443   11m
slave-harbor-ingress    <none>   registry.slave.codehorse.com    192.168.1.140   80, 443   2m1s
