# k8s集群所有节点安装nerdctl工具
cd /usr/local/src
wget https://github.com/containerd/nerdctl/releases/download/v1.7.2/nerdctl-1.7.2-linux-amd64.tar.gz
tar xvf nerdctl-1.7.2-linux-amd64.tar.gz -C /usr/local/bin/
nerdctl version
nerdctl --help | grep toml
mkdir /etc/nerdctl
vim /etc/nerdctl/nerdctl.toml
################################################################################
namespace = "k8s.io"
debug = false
debug_full = false
insecure_registry = true
################################################################################
nerdctl ps
nerdctl -n k8s.io ps

# k8s所有节点修改containerd配置文件，使其能登陆到harbor
vim /etc/containerd/config.toml
# 添加如下内容
########################################################################################################
[plugins."io.containerd.grpc.v1.cri".registry.configs."registry.master.codehorse.com"]
          [plugins."io.containerd.grpc.v1.cri".registry.configs."registry.master.codehorse.com".tls]
            insecure_skip_verify = true
          [plugins."io.containerd.grpc.v1.cri".registry.configs."registry.master.codehorse.com".auth]
            username = "admin"
            password = "Root_123"

        [plugins."io.containerd.grpc.v1.cri".registry.configs."registry.slave.codehorse.com"]
          [plugins."io.containerd.grpc.v1.cri".registry.configs."registry.slave.codehorse.com".tls]
            insecure_skip_verify = true
          [plugins."io.containerd.grpc.v1.cri".registry.configs."registry.slave.codehorse.com".auth]
            username = "admin"
            password = "Root_123"
########################################################################################################
systemctl daemon-reload && systemctl restart containerd

# k8s所有节点修改host文件添加地址解析
vim /etc/hosts
########################################################################################################
192.168.1.140 registry.master.codehorse.com registry.slave.codehorse.com
########################################################################################################

# k8s所有节点使用nerdctl登陆harbor验证
nerdctl login --username admin --password Root_123 --insecure-registry registry.master.codehorse.com
nerdctl login --username admin --password Root_123 --insecure-registry registry.slave.codehorse.com

# 使用主节点推送镜像至harbor master
root@master:~# nerdctl image pull nginx:latest
root@master:~# nerdctl image ls -a | grep nginx
nginx                                                              latest      84c52dfd55c4    10 seconds ago    linux/amd64    191.9 MiB    67.3 MiB
root@master:~# nerdctl image tag nginx:latest registry.master.codehorse.com/baseimages/nginx:v1
root@master:~# nerdctl image ls -a | grep nginx
nginx                                                              latest      84c52dfd55c4    About a minute ago    linux/amd64    191.9 MiB    67.3 MiB
registry.master.codehorse.com/baseimages/nginx                     v1          84c52dfd55c4    16 seconds ago        linux/amd64    191.9 MiB    67.3 MiB
# 推送镜像至harbor master
root@master:~# nerdctl image push registry.master.codehorse.com/baseimages/nginx:v1
可以观察到harbor slave也同步到了nginx镜像

# 使用主节点推送镜像至harbor slave
root@master:~# nerdctl image pull busybox:latest
root@master:~# nerdctl image ls -a | grep busybox
busybox                                                            latest      6d9ac9237a84    34 seconds ago    linux/amd64    4.2 MiB      2.1 MiB
root@master:~# nerdctl image tag busybox:latest registry.slave.codehorse.com/baseimages/busybox:v1
root@master:~# nerdctl image ls -a | grep busybox
busybox                                                            latest      6d9ac9237a84    About a minute ago    linux/amd64    4.2 MiB      2.1 MiB
registry.slave.codehorse.com/baseimages/busybox                    v1          6d9ac9237a84    15 seconds ago        linux/amd64    4.2 MiB      2.1 MiB
# 推送镜像至harbor slave
root@master:~# nerdctl image push registry.slave.codehorse.com/baseimages/busybox:v1
可以观察到harbor master也同步了busybox镜像

# 使用主节点从harbor master拉取镜像
root@master:~# nerdctl image rm -f registry.master.codehorse.com/baseimages/nginx:v1
root@master:~# nerdctl image ls -a | grep nginx
nginx                                                              latest      84c52dfd55c4    11 minutes ago    linux/amd64    191.9 MiB    67.3 MiB
root@master:~# nerdctl image pull registry.master.codehorse.com/baseimages/nginx:v1
root@master:~# nerdctl image ls -a | grep nginx
nginx                                                              latest      84c52dfd55c4    12 minutes ago    linux/amd64    191.9 MiB    67.3 MiB
registry.master.codehorse.com/baseimages/nginx                     v1          2cbad4c80a42    12 seconds ago    linux/amd64    191.9 MiB    67.3 MiB

# 使用主节点从harbor slave拉取镜像
root@master:~# nerdctl image rm -f registry.slave.codehorse.com/baseimages/busybox:v1
root@master:~# nerdctl image ls -a | grep busybox
busybox                                                            latest      6d9ac9237a84    7 minutes ago     linux/amd64    4.2 MiB      2.1 MiB
root@master:~# nerdctl image pull registry.slave.codehorse.com/baseimages/busybox:v1
root@master:~# nerdctl image ls -a | grep busybox
busybox                                                            latest      6d9ac9237a84    7 minutes ago         linux/amd64    4.2 MiB      2.1 MiB
registry.slave.codehorse.com/baseimages/busybox                    v1          894335f20907    8 seconds ago         linux/amd64    4.2 MiB      2.1 MiB
