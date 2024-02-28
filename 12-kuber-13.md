# Домашнее задание к занятию «Как работает сеть в K8s»

### Инструменты и дополнительные материалы, которые пригодятся для выполнения задания

1. [Документация Calico](https://www.tigera.io/project-calico/).
2. [Network Policy](https://kubernetes.io/docs/concepts/services-networking/network-policies/).
3. [About Network Policy](https://docs.projectcalico.org/about/about-network-policy).

-----

### Создаем кластер из 3-ех нод
Создание ВМ:
```sh
D:\projects\devops-netology\assets\12-kuber-13\terraform>terraform apply
Apply complete! Resources: 6 added, 0 changed, 0 destroyed.

Outputs:

master_ip = "master - 10.0.1.3(158.160.126.107)"
worker_ips = [
  "worker-0 - 10.0.1.25(158.160.99.175)",
  "worker-1 - 10.0.1.26(158.160.127.217)",
]
```
Создание кластера с помощью kubespray:
```sh
Friday 02 February 2024  19:08:09 +0300 (0:00:00.128)       0:20:11.222 *******
Friday 02 February 2024  19:08:09 +0300 (0:00:00.121)       0:20:11.343 *******
Friday 02 February 2024  19:08:09 +0300 (0:00:00.112)       0:20:11.455 *******

PLAY RECAP *************************************************************************************************************
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
node1                      : ok=741  changed=144  unreachable=0    failed=0    skipped=1163 rescued=0    ignored=6
node2                      : ok=585  changed=114  unreachable=0    failed=0    skipped=759  rescued=0    ignored=2
node3                      : ok=585  changed=114  unreachable=0    failed=0    skipped=755  rescued=0    ignored=2

Friday 02 February 2024  19:08:10 +0300 (0:00:00.899)       0:20:12.355 *******
===============================================================================
download : Download_file | Validate mirrors -------------------------------------------------------------------- 37.40s
kubernetes/preinstall : Install packages requirements ---------------------------------------------------------- 36.47s
network_plugin/calico : Wait for calico kubeconfig to be created ----------------------------------------------- 35.81s
container-engine/containerd : Download_file | Validate mirrors ------------------------------------------------- 33.04s
container-engine/runc : Download_file | Validate mirrors ------------------------------------------------------- 32.86s
kubernetes/control-plane : Kubeadm | Initialize first master --------------------------------------------------- 28.96s
etcd : Gen_certs | Write etcd member/admin and kube_control_plane client certs to other etcd nodes ------------- 25.41s
download : Download_file | Download item ----------------------------------------------------------------------- 21.74s
etcd : Reload etcd --------------------------------------------------------------------------------------------- 21.42s
kubernetes/preinstall : Preinstall | wait for the apiserver to be running -------------------------------------- 17.80s
kubernetes-apps/ansible : Kubernetes Apps | Lay Down CoreDNS templates ----------------------------------------- 17.60s
download : Download_container | Download image if required ----------------------------------------------------- 14.80s
kubernetes/kubeadm : Join to cluster --------------------------------------------------------------------------- 13.32s
download : Download_container | Download image if required ----------------------------------------------------- 12.86s
kubespray-defaults : Gather ansible_default_ipv4 from all hosts ------------------------------------------------ 11.11s
kubernetes-apps/ansible : Kubernetes Apps | Start Resources ---------------------------------------------------- 10.56s
etcd : Gen_certs | Gather etcd member/admin and kube_control_plane client certs from first etcd node ----------- 10.39s
etcdctl_etcdutl : Extract_file | Unpacking archive ------------------------------------------------------------- 10.32s
download : Download_container | Download image if required ----------------------------------------------------- 10.30s
network_plugin/calico : Calico | Create calico manifests ------------------------------------------------------- 10.30s
```


### Задание 1. Создать сетевую политику или несколько политик для обеспечения доступа

1. Создать deployment'ы приложений frontend, backend и cache и соответсвующие сервисы.
2. В качестве образа использовать network-multitool.
3. Разместить поды в namespace App.
```sh
ubuntu@node1:~/manifects$ kubectl create ns app
namespace/app created
ubuntu@node1:~/manifects$ kubectl apply -f deployment.yaml -n app
deployment.apps/frontend created
service/frontend-svc created
deployment.apps/backend created
service/backend-svc created
deployment.apps/cache created
service/cache-svc created
```
Проверка доступа:
```sh
ubuntu@node1:~/manifects$ kubectl exec -it -n app frontend-694ddc5ccd-bghts -- /bin/bash
frontend-694ddc5ccd-bghts:/# curl backend-svc
WBITT Network MultiTool (with NGINX) - backend-5c65d86cd4-8plqb - 10.233.75.4 - HTTP: 80 , HTTPS: 443 . (Formerly praqma/network-multitool)
frontend-694ddc5ccd-bghts:/# curl cache-svc
WBITT Network MultiTool (with NGINX) - cache-5db76885cb-l7bww - 10.233.71.6 - HTTP: 80 , HTTPS: 443 . (Formerly praqma/network-multitool)

ubuntu@node1:~/manifects$ kubectl exec -it -n app backend-5c65d86cd4-8plqb -- /bin/bash
backend-5c65d86cd4-8plqb:/# curl frontend-svc
WBITT Network MultiTool (with NGINX) - frontend-694ddc5ccd-bghts - 10.233.71.5 - HTTP: 80 , HTTPS: 443 . (Formerly praqma/network-multitool)
backend-5c65d86cd4-8plqb:/# curl cache-svc
WBITT Network MultiTool (with NGINX) - cache-5db76885cb-l7bww - 10.233.71.6 - HTTP: 80 , HTTPS: 443 . (Formerly praqma/network-multitool)
```
4. Создать политики, чтобы обеспечить доступ frontend -> backend -> cache. Другие виды подключений должны быть запрещены.
Запрет всего
5. Продемонстрировать, что трафик разрешён и запрещён.

```sh
ubuntu@node1:~/manifects$ kubectl apply -f network-policy-deny-all.yaml -n app
networkpolicy.networking.k8s.io/ingress-deny-all created
ubuntu@node1:~/manifects$ kubectl exec -it -n app frontend-694ddc5ccd-bghts -- /bin/bash
frontend-694ddc5ccd-bghts:/# curl cache-svc
^C
frontend-694ddc5ccd-bghts:/# curl backend-svc
^C
```

Применение настроек backend
```sh
ubuntu@node1:~/manifects$ nano network-policy-backend.yaml
ubuntu@node1:~/manifects$ kubectl apply -f network-policy-backend.yaml -n app
networkpolicy.networking.k8s.io/allow-frontend-to-backend created
ubuntu@node1:~/manifects$ kubectl exec -it -n app frontend-694ddc5ccd-bghts -- /bin/bash
frontend-694ddc5ccd-bghts:/# curl backend-svc
WBITT Network MultiTool (with NGINX) - backend-5c65d86cd4-8plqb - 10.233.75.4 - HTTP: 80 , HTTPS: 443 . (Formerly praqma/network-multitool)
frontend-694ddc5ccd-bghts:/# curl cache-svc
^C
frontend-694ddc5ccd-bghts:/#
```

Применение настроек cache
```sh
ubuntu@node1:~/manifects$ nano network-policy-cache.yaml
ubuntu@node1:~/manifects$ kubectl apply -f network-policy-cache.yaml -n app
networkpolicy.networking.k8s.io/allow-backend-to-cache created
ubuntu@node1:~/manifects$ kubectl exec -it -n app backend-5c65d86cd4-8plqb -- /bin/bash
backend-5c65d86cd4-8plqb:/# curl frontend-svc
^C
backend-5c65d86cd4-8plqb:/# curl cache-svc
WBITT Network MultiTool (with NGINX) - cache-5db76885cb-l7bww - 10.233.71.6 - HTTP: 80 , HTTPS: 443 . (Formerly praqma/network-multitool)
backend-5c65d86cd4-8plqb:/#
```

Манифесты:
- [deployment.yaml](/assets/12-kuber-13/manifecsts/deployment.yaml)
- [network-policy-deny-all.yaml](/assets/12-kuber-13/manifecsts/network-policy-deny-all.yaml)
- [network-policy-backend.yaml](/assets/12-kuber-13/manifecsts/network-policy-backend.yaml)
- [network-policy-cache.yaml](/assets/12-kuber-13/manifecsts/network-policy-cache.yaml)
