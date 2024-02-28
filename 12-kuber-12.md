# Домашнее задание к занятию «Установка Kubernetes»

### Цель задания

Установить кластер K8s.

### Чеклист готовности к домашнему заданию

1. Развёрнутые ВМ с ОС Ubuntu 20.04-lts.


### Инструменты и дополнительные материалы, которые пригодятся для выполнения задания

1. [Инструкция по установке kubeadm](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/).
2. [Документация kubespray](https://kubespray.io/).

-----

### Задание 1. Установить кластер k8s с 1 master node

1. Подготовка работы кластера из 5 нод: 1 мастер и 4 рабочие ноды.
2. В качестве CRI — containerd.
3. Запуск etcd производить на мастере.
4. Способ установки выбрать самостоятельно.

Подготовка окружения:
```sh
D:\projects\devops-netology\assets\12-kuber-11\terraform>terraform init

Initializing the backend...
Terraform has been successfully initialized!

D:\projects\devops-netology\assets\12-kuber-11\terraform>terraform plan
data.yandex_compute_image.ubuntu: Reading...
data.yandex_compute_image.ubuntu: Read complete after 2s [id=fd82qs98ootbak6lkmmj]
Plan: 8 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + master_ip  = (known after apply)
  + worker_ips = [
      + (known after apply),
      + (known after apply),
      + (known after apply),
      + (known after apply),
    ]
D:\projects\devops-netology\assets\12-kuber-11\terraform>terraform apply
data.yandex_compute_image.ubuntu: Reading...
Apply complete! Resources: 8 added, 0 changed, 0 destroyed.

Outputs:

master_ip = "master - 10.0.1.29(158.160.35.143)"
worker_ips = [
  "worker-0 - 10.0.1.26(158.160.101.250)",
  "worker-1 - 10.0.1.24(158.160.123.190)",
  "worker-2 - 10.0.1.31(158.160.103.65)",
  "worker-3 - 10.0.1.35(158.160.104.73)",
]
```

Подготовка kubespray
```sh
ubuntu@fhm6qodc3d41q3u7v975:~$ sudo apt install git
ubuntu@fhm6qodc3d41q3u7v975:~$ git clone https://github.com/kubernetes-sigs/kubespray
ubuntu@fhm6qodc3d41q3u7v975:~$  sudo apt install python3.9
ubuntu@fhm6qodc3d41q3u7v975:~$ curl -sS https://bootstrap.pypa.io/get-pip.py | python3.9
ubuntu@fhm6qodc3d41q3u7v975:~$ python3.9 -m pip --version
pip 23.3.2 from /home/ubuntu/.local/lib/python3.9/site-packages/pip (python 3.9)
ubuntu@fhm6qodc3d41q3u7v975:~/kubespray$ python3.9 -m pip install -r requirements.txt
ubuntu@fhm6qodc3d41q3u7v975:~/kubespray$ cp -rfp inventory/sample inventory/mycluster
ubuntu@fhm6qodc3d41q3u7v975:~/kubespray$ declare -a IPS=(10.0.1.29 10.0.1.26 10.0.1.24 10.0.1.31 10.0.1.35)
ubuntu@fhm6qodc3d41q3u7v975:~/kubespray$ CONFIG_FILE=inventory/mycluster/hosts.yaml python3.9 contrib/inventory_builder/inventory.py ${IPS[@]}
DEBUG: Adding group all
DEBUG: Adding group kube_control_plane
DEBUG: Adding group kube_node
DEBUG: Adding group etcd
DEBUG: Adding group k8s_cluster
DEBUG: Adding group calico_rr
DEBUG: adding host node1 to group all
DEBUG: adding host node2 to group all
DEBUG: adding host node3 to group all
DEBUG: adding host node4 to group all
DEBUG: adding host node5 to group all
DEBUG: adding host node1 to group etcd
DEBUG: adding host node2 to group etcd
DEBUG: adding host node3 to group etcd
DEBUG: adding host node1 to group kube_control_plane
DEBUG: adding host node2 to group kube_control_plane
DEBUG: adding host node1 to group kube_node
DEBUG: adding host node2 to group kube_node
DEBUG: adding host node3 to group kube_node
DEBUG: adding host node4 to group kube_node
DEBUG: adding host node5 to group kube_node

// добавляем на мастер ноду приватный ключ и тестируем подключение
nano id_ed25519
sudo chmod 700 id_ed25519
ubuntu@fhm6qodc3d41q3u7v975:~/.ssh$ ssh ubuntu@10.0.1.26
Welcome to Ubuntu 20.04.6 LTS (GNU/Linux 5.4.0-170-generic x86_64)

// Добавляем ansible в PATH
nano ~/.bashrc
source ~/.bashrc
ubuntu@fhm6qodc3d41q3u7v975:~/kubespray$ ansible --version
ansible [core 2.15.9]
  config file = /home/ubuntu/kubespray/ansible.cfg
  configured module search path = ['/home/ubuntu/kubespray/library']
  ansible python module location = /home/ubuntu/.local/lib/python3.9/site-packages/ansible
  ansible collection location = /home/ubuntu/.ansible/collections:/usr/share/ansible/collections
  executable location = /home/ubuntu/.local/bin/ansible
  python version = 3.9.5 (default, Nov 23 2021, 15:27:38) [GCC 9.3.0] (/usr/bin/python3.9)
  jinja version = 3.1.2
  libyaml = False

// Установка кластера

ansible-playbook -i inventory/mycluster/hosts.yaml cluster.yml -b -v
...
Tuesday 30 January 2024  10:06:57 +0000 (0:00:00.114)       0:26:10.413 *******
Tuesday 30 January 2024  10:06:57 +0000 (0:00:00.071)       0:26:10.484 *******
Tuesday 30 January 2024  10:06:57 +0000 (0:00:00.068)       0:26:10.553 *******

PLAY RECAP ************************************************************************************************************
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
node1                      : ok=743  changed=143  unreachable=0    failed=0    skipped=1157 rescued=0    ignored=6
node2                      : ok=516  changed=91   unreachable=0    failed=0    skipped=723  rescued=0    ignored=1
node3                      : ok=516  changed=91   unreachable=0    failed=0    skipped=719  rescued=0    ignored=1
node4                      : ok=516  changed=91   unreachable=0    failed=0    skipped=719  rescued=0    ignored=1
node5                      : ok=516  changed=91   unreachable=0    failed=0    skipped=719  rescued=0    ignored=1

Tuesday 30 January 2024  10:06:58 +0000 (0:00:00.494)       0:26:11.048 *******
===============================================================================
download : Download_file | Download item ---------------------------------------------------------------------- 79.89s
download : Download_file | Download item ---------------------------------------------------------------------- 65.58s
kubernetes/preinstall : Install packages requirements --------------------------------------------------------- 51.44s
network_plugin/calico : Wait for calico kubeconfig to be created ---------------------------------------------- 45.64s
kubernetes/control-plane : Kubeadm | Initialize first master -------------------------------------------------- 41.38s
download : Download_file | Download item ---------------------------------------------------------------------- 33.83s
container-engine/crictl : Download_file | Download item ------------------------------------------------------- 23.28s
download : Download_container | Download image if required ---------------------------------------------------- 22.92s
container-engine/containerd : Download_file | Download item --------------------------------------------------- 22.87s
kubernetes/preinstall : Preinstall | wait for the apiserver to be running ------------------------------------- 22.21s
container-engine/runc : Download_file | Download item --------------------------------------------------------- 22.16s
container-engine/nerdctl : Download_file | Download item ------------------------------------------------------ 22.10s
download : Download_container | Download image if required ---------------------------------------------------- 17.36s
download : Download_container | Download image if required ---------------------------------------------------- 17.24s
container-engine/crictl : Extract_file | Unpacking archive ---------------------------------------------------- 16.68s
container-engine/nerdctl : Extract_file | Unpacking archive --------------------------------------------------- 15.76s
kubernetes/kubeadm : Join to cluster -------------------------------------------------------------------------- 14.24s
container-engine/runc : Download_file | Validate mirrors ------------------------------------------------------ 13.20s
container-engine/crictl : Download_file | Validate mirrors ---------------------------------------------------- 13.16s
container-engine/nerdctl : Download_file | Validate mirrors --------------------------------------------------- 13.12s
```
Тестирование доступа
```sh
mkdir $HOME/.kube
ubuntu@node1:~$ sudo cp /etc/kubernetes/admin.conf $HOME/.kube/config
ubuntu@node1:~$ sudo chown $(id -u):$(id -g) $HOME/.kube/config
ubuntu@node1:~$ nano deployment.yaml
ubuntu@node1:~$ kubectl get nodes
NAME    STATUS   ROLES           AGE   VERSION
node1   Ready    control-plane   99m   v1.28.6
node2   Ready    <none>          98m   v1.28.6
node3   Ready    <none>          98m   v1.28.6
node4   Ready    <none>          98m   v1.28.6
node5   Ready    <none>          98m   v1.28.6
ubuntu@node1:~$ kubectl apply -f deployment.yaml
deployment.apps/nginx-deployment created
service/nginx-svc created
ubuntu@node1:~$ kubectl port-forward svc/nginx-svc 8080:80
Forwarding from 127.0.0.1:8080 -> 80
Forwarding from [::1]:8080 -> 80
Handling connection for 8080
```
```sh
ubuntu@node1:~$ curl localhost:8080
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
html { color-scheme: light dark; }
body { width: 35em; margin: 0 auto;
font-family: Tahoma, Verdana, Arial, sans-serif; }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<p>If you see this page, the nginx web server is successfully installed and
working. Further configuration is required.</p>

<p>For online documentation and support please refer to
<a href="http://nginx.org/">nginx.org</a>.<br/>
Commercial support is available at
<a href="http://nginx.com/">nginx.com</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>
```

## Дополнительные задания (со звёздочкой)

**Настоятельно рекомендуем выполнять все задания под звёздочкой.** Их выполнение поможет глубже разобраться в материале.   
Задания под звёздочкой необязательные к выполнению и не повлияют на получение зачёта по этому домашнему заданию. 

------
### Задание 2*. Установить HA кластер

1. Установить кластер в режиме HA.
2. Использовать нечётное количество Master-node.
3. Для cluster ip использовать keepalived или другой способ.
