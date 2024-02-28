# Домашнее задание к занятию «Управление доступом»

### Инструменты / дополнительные материалы, которые пригодятся для выполнения задания

1. [Описание](https://kubernetes.io/docs/reference/access-authn-authz/rbac/) RBAC.
2. [Пользователи и авторизация RBAC в Kubernetes](https://habr.com/ru/company/flant/blog/470503/).
3. [RBAC with Kubernetes in Minikube](https://medium.com/@HoussemDellai/rbac-with-kubernetes-in-minikube-4deed658ea7b).

------

### Задание 1. Создайте конфигурацию для подключения пользователя

1. Создайте и подпишите SSL-сертификат для подключения к кластеру.
```sh
qwuen@MSI:/mnt/d/projects/devops-netology/assets/12-kuber-09$ cd certs/
qwuen@MSI:/mnt/d/projects/devops-netology/assets/12-kuber-09/certs$ openssl genrsa -out test.key 2048
qwuen@MSI:/mnt/d/projects/devops-netology/assets/12-kuber-09/certs$ openssl req -key test.key -new -out test.csr -subj "/CN=test/O=netology"
```
```sh
vagrant@kuber:~$ openssl x509 -req -in /home/vagrant/test.csr -CA /var/snap/microk8s/current/certs/ca.crt -CAkey /var/snap/microk8s/current/certs/ca.key -CAcreateserial -out test.crt -days 365
Signature ok
subject=CN = test, O = netology
Getting CA Private Key
vagrant@kuber:~$ ls
snap  test.crt  test.csr
```
2. Настройте конфигурационный файл kubectl для подключения.
```sh
qwuen@MSI:/mnt/d/projects/devops-netology/assets/12-kuber-09/certs$ kubectl config set-credentials test --client-certificate=test.crt --client-key=test.key
User "test" set.
qwuen@MSI:/mnt/d/projects/devops-netology/assets/12-kuber-09/certs$ kubectl config get-contexts
CURRENT   NAME             CLUSTER            AUTHINFO         NAMESPACE
          docker-desktop   docker-desktop     docker-desktop
*         microk8s         microk8s-cluster   admin
qwuen@MSI:/mnt/d/projects/devops-netology/assets/12-kuber-09/certs$ kubectl config set-context test-context --cluster=microk8s-cluster --user=test
Context "test-context" created.
qwuen@MSI:/mnt/d/projects/devops-netology/assets/12-kuber-09/certs$ kubectl config use-context test-context
Switched to context "test-context".
qwuen@MSI:/mnt/d/projects/devops-netology/assets/12-kuber-09/certs$ kubectl config current-context
test-context
```
3. Создайте роли и все необходимые настройки для пользователя.
```sh
qwuen@MSI:/mnt/d/projects/devops-netology/assets/12-kuber-09/certs$ kubectl config use-context microk8s
Switched to context "microk8s".
qwuen@MSI:/mnt/d/projects/devops-netology/assets/12-kuber-09/certs$ kubectl create ns my
namespace/my created
qwuen@MSI:/mnt/d/projects/devops-netology/assets/12-kuber-09/certs$ cd ../manifests/
qwuen@MSI:/mnt/d/projects/devops-netology/assets/12-kuber-09/manifests$ kubectl apply -f role.yml -n my
role.rbac.authorization.k8s.io/test-role created
qwuen@MSI:/mnt/d/projects/devops-netology/assets/12-kuber-09/manifests$ kubectl apply -f role-bindings.yml -n my
rolebinding.rbac.authorization.k8s.io/test-rolebinding created
qwuen@MSI:/mnt/d/projects/devops-netology/assets/12-kuber-09/manifests$
```
4. Предусмотрите права пользователя. Пользователь может просматривать логи подов и их конфигурацию (`kubectl logs pod <pod_id>`, `kubectl describe pod <pod_id>`).
```sh
qwuen@MSI:/mnt/d/projects/devops-netology/assets/12-kuber-09/manifests$ kubectl config use-context test-context
Switched to context "test-context".
qwuen@MSI:/mnt/d/projects/devops-netology/assets/12-kuber-09/manifests$ kubectl apply -f deployment.yml -n my
deployment.apps/deployment created
qwuen@MSI:/mnt/d/projects/devops-netology/assets/12-kuber-09/manifests$ kubectl get po
Error from server (Forbidden): pods is forbidden: User "test" cannot list resource "pods" in API group "" in the namespace "default"
qwuen@MSI:/mnt/d/projects/devops-netology/assets/12-kuber-09/manifests$ kubectl get po -n my
NAME                          READY   STATUS    RESTARTS   AGE
deployment-565dcdcfdc-x2jfj   1/1     Running   0          33s
qwuen@MSI:/mnt/d/projects/devops-netology/assets/12-kuber-09/manifests$ kubectl describe po deployment-565dcdcfdc-x2jfj
-n my
Name:             deployment-565dcdcfdc-x2jfj
Namespace:        my
Priority:         0
Service Account:  default
Node:             kuber/10.0.2.15
Start Time:       Thu, 25 Jan 2024 16:19:07 +0300
Labels:           app=myapp
                  pod-template-hash=565dcdcfdc
Annotations:      cni.projectcalico.org/containerID: 523d9483ab8f4161111e99f7e1c6607a62b7d4bf0dd935fb0a5420260cab1cc7
                  cni.projectcalico.org/podIP: 10.1.106.152/32
                  cni.projectcalico.org/podIPs: 10.1.106.152/32
Status:           Running
IP:               10.1.106.152
....

qwuen@MSI:/mnt/d/projects/devops-netology/assets/12-kuber-09/manifests$ kubectl logs deployment-565dcdcfdc-x2jfj -n my
/docker-entrypoint.sh: /docker-entrypoint.d/ is not empty, will attempt to perform configuration
/docker-entrypoint.sh: Looking for shell scripts in /docker-entrypoint.d/
/docker-entrypoint.sh: Launching /docker-entrypoint.d/10-listen-on-ipv6-by-default.sh
10-listen-on-ipv6-by-default.sh: info: Getting the checksum of /etc/nginx/conf.d/default.conf
10-listen-on-ipv6-by-default.sh: info: Enabled listen on IPv6 in /etc/nginx/conf.d/default.conf
/docker-entrypoint.sh: Sourcing /docker-entrypoint.d/15-local-resolvers.envsh
/docker-entrypoint.sh: Launching /docker-entrypoint.d/20-envsubst-on-templates.sh
/docker-entrypoint.sh: Launching /docker-entrypoint.d/30-tune-worker-processes.sh
/docker-entrypoint.sh: Configuration complete; ready for start up
2024/01/25 13:19:09 [notice] 1#1: using the "epoll" event method
2024/01/25 13:19:09 [notice] 1#1: nginx/1.25.3
2024/01/25 13:19:09 [notice] 1#1: built by gcc 12.2.0 (Debian 12.2.0-14)
2024/01/25 13:19:09 [notice] 1#1: OS: Linux 5.4.0-144-generic
2024/01/25 13:19:09 [notice] 1#1: getrlimit(RLIMIT_NOFILE): 65536:65536
2024/01/25 13:19:09 [notice] 1#1: start worker processes
2024/01/25 13:19:09 [notice] 1#1: start worker process 30
2024/01/25 13:19:09 [notice] 1#1: start worker process 31
2024/01/25 13:19:09 [notice] 1#1: start worker process 32
2024/01/25 13:19:09 [notice] 1#1: start worker process 33
```
5. Предоставьте манифесты и скриншоты и/или вывод необходимых команд.
Манифесты:
- [deployment.yml](/assets/12-kuber-09/manifests/deployment.yml)
- [role.yml](/assets/12-kuber-09/manifests/role.yml)
- [role-bindings.yml](/assets/12-kuber-09/manifests/role-bindings.yml)
