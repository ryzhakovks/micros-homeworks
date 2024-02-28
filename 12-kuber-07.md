# Домашнее задание к занятию «Хранение в K8s. Часть 2»

### Дополнительные материалы для выполнения задания

1. [Инструкция по установке NFS в MicroK8S](https://microk8s.io/docs/nfs). 
2. [Описание Persistent Volumes](https://kubernetes.io/docs/concepts/storage/persistent-volumes/). 
3. [Описание динамического провижининга](https://kubernetes.io/docs/concepts/storage/dynamic-provisioning/). 
4. [Описание Multitool](https://github.com/wbitt/Network-MultiTool).

------

### Задание 1

Создать Deployment приложения, использующего локальный PV, созданный вручную.

1. Создать Deployment приложения, состоящего из контейнеров busybox и multitool.
```sh
qwuen@LAPTOP-2QLN04RI:/mnt/c/projects/home/devops-netology/assets/12-kuber-07/manifests$ kubectl apply -f deployment.yml -n netology
deployment.apps/deployment-1 created
qwuen@LAPTOP-2QLN04RI:/mnt/c/projects/home/devops-netology/assets/12-kuber-07/manifests$ kubectl get po -n netology
NAME                            READY   STATUS    RESTARTS   AGE
deployment-1-54c667886c-9rdvn   2/2     Running   0          20s
```
2. Создать PV и PVC для подключения папки на локальной ноде, которая будет использована в поде.
```sh
qwuen@LAPTOP-2QLN04RI:/mnt/c/projects/home/devops-netology/assets/12-kuber-07/manifests$ ls
pv-1.yml  pvc-1.yml
qwuen@LAPTOP-2QLN04RI:/mnt/c/projects/home/devops-netology/assets/12-kuber-07/manifests$ kubectl apply -f pv-1.yml -n netology
persistentvolume/pv-1 created
qwuen@LAPTOP-2QLN04RI:/mnt/c/projects/home/devops-netology/assets/12-kuber-07/manifests$ kubectl apply -f pvc-1.yml -n netology
persistentvolumeclaim/pvc-1 created
qwuen@LAPTOP-2QLN04RI:/mnt/c/projects/home/devops-netology/assets/12-kuber-07/manifests$ kubectl get pv -n netology
NAME   CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS      CLAIM   STORAGECLASS   REASON   AGE
pv-1   1Gi        RWO            Retain           Available           host-path               38s
qwuen@LAPTOP-2QLN04RI:/mnt/c/projects/home/devops-netology/assets/12-kuber-07/manifests$ kubectl get pvc -n netology
NAME    STATUS    VOLUME   CAPACITY   ACCESS MODES   STORAGECLASS   AGE
pvc-1   Pending                                      host-path      29s
qwuen@LAPTOP-2QLN04RI:/mnt/c/projects/home/devops-netology/assets/12-kuber-07/manifests$ kubectl get pvc -n netology
NAME    STATUS   VOLUME   CAPACITY   ACCESS MODES   STORAGECLASS   AGE
pvc-1   Bound    pv-1     1Gi        RWO            host-path      42s
```
3. Продемонстрировать, что multitool может читать файл, в который busybox пишет каждые пять секунд в общей директории. 
```sh 
qwuen@LAPTOP-2QLN04RI:/mnt/c/projects/home/devops-netology/assets/12-kuber-07/manifests$ kubectl exec -it -n netology deployment-1-54c667886c-9rdvn --container multitool -- bash
deployment-1-54c667886c-9rdvn:/# tail -5 /input/output.txt
17:33:43 2023-12-24
17:33:48 2023-12-24
17:33:53 2023-12-24
17:33:58 2023-12-24
17:34:03 2023-12-24
deployment-1-54c667886c-9rdvn:/#
```
4. Удалить Deployment и PVC. Продемонстрировать, что после этого произошло с PV. Пояснить, почему.
```sh
qwuen@LAPTOP-2QLN04RI:/mnt/c/projects/home/devops-netology/assets/12-kuber-07/manifests$ kubectl delete -f deployment.ym
l -n netology
deployment.apps "deployment-1" deleted
qwuen@LAPTOP-2QLN04RI:/mnt/c/projects/home/devops-netology/assets/12-kuber-07/manifests$ kubectl delete -f pvc-1.yml -n
netology
persistentvolumeclaim "pvc-1" deleted
qwuen@LAPTOP-2QLN04RI:/mnt/c/projects/home/devops-netology/assets/12-kuber-07/manifests$ kubectl get po -n netology
No resources found in netology namespace.
qwuen@LAPTOP-2QLN04RI:/mnt/c/projects/home/devops-netology/assets/12-kuber-07/manifests$ kubectl get pvc -n netology
No resources found in netology namespace.
qwuen@LAPTOP-2QLN04RI:/mnt/c/projects/home/devops-netology/assets/12-kuber-07/manifests$ kubectl get pv -n netology
NAME   CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS     CLAIM            STORAGECLASS   REASON   AGE
pv-1   1Gi        RWO            Retain           Released   netology/pvc-1   host-path               19m
```
После удаления PersistentVolumeClaim, PersistentVolume остаётся и отмечается "released".  
Данный PersistentVolume будет недоступен для новых PersistentVolumeClaim, т.к. содержит данные предыдущего PersistentVolumeClaim.

5. Продемонстрировать, что файл сохранился на локальном диске ноды. Удалить PV.  Продемонстрировать что произошло с файлом после удаления PV. Пояснить, почему.
```sh
vagrant@kuber:~$ ls /
bin   data1  etc   lib    lib64   lost+found  mnt  proc  run   snap  swap.img  tmp  vagrant
boot  dev    home  lib32  libx32  media       opt  root  sbin  srv   sys       usr  var
vagrant@kuber:~$ ls /data1
pv1
vagrant@kuber:~$ ls /data1/pv1
output.txt
```

```sh
qwuen@LAPTOP-2QLN04RI:/mnt/c/projects/home/devops-netology/assets/12-kuber-07/manifests$ kubectl delete -f pv-1.yml -n n
etology
Warning: deleting cluster-scoped resources, not scoped to the provided namespace
persistentvolume "pv-1" deleted
qwuen@LAPTOP-2QLN04RI:/mnt/c/projects/home/devops-netology/assets/12-kuber-07/manifests$ kubectl get pv -n netology
No resources found
```

```sh
vagrant@kuber:~$ ls /data1/pv1
output.txt
```
Политика Reclaim Policy: Retain говорит, что после удаления PV ресурсы из внешних провайдеров автоматически не удаляются.  

5. Предоставить манифесты, а также скриншоты или вывод необходимых команд.

- [pv-1.yml](/assets/12-kuber-07/manifests/pv-1.yml)
- [pvc-1.yml](/assets/12-kuber-07/manifests/pvc-1.yml)
- [deployment.yml](/assets/12-kuber-07/manifests/deployment.yml)

------

### Задание 2

Создать Deployment приложения, которое может хранить файлы на NFS с динамическим созданием PV.

1. Включить и настроить NFS-сервер на MicroK8S.
```sh
vagrant@kuber:~$ microk8s enable community
Infer repository core for addon community
Cloning into '/var/snap/microk8s/common/addons/community'...
done.
Community repository is now enabled
vagrant@kuber:~$ microk8s enable nfs
Infer repository community for addon nfs
Infer repository core for addon helm3
Addon core/helm3 is already enabled
Installing NFS Server Provisioner - Helm Chart 1.4.0

Node Name not defined. NFS Server Provisioner will be deployed on random Microk8s Node.

If you want to use a dedicated (large disk space) Node as NFS Server, disable the Addon and start over: microk8s enable nfs -n NODE_NAME
Lookup Microk8s Node name as: kubectl get node -o yaml | grep 'kubernetes.io/hostname'

Preparing PV for NFS Server Provisioner

persistentvolume/data-nfs-server-provisioner-0 created
"nfs-ganesha-server-and-external-provisioner" has been added to your repositories
Release "nfs-server-provisioner" does not exist. Installing it now.
NAME: nfs-server-provisioner
LAST DEPLOYED: Sun Dec 24 18:10:55 2023
NAMESPACE: nfs-server-provisioner
STATUS: deployed
REVISION: 1
TEST SUITE: None
NOTES:
The NFS Provisioner service has now been installed.

A storage class named 'nfs' has now been created
and is available to provision dynamic volumes.

You can use this storageclass by creating a `PersistentVolumeClaim` with the
correct storageClassName attribute. For example:

    ---
    kind: PersistentVolumeClaim
    apiVersion: v1
    metadata:
      name: test-dynamic-volume-claim
    spec:
      storageClassName: "nfs"
      accessModes:
        - ReadWriteOnce
      resources:
        requests:
          storage: 100Mi

NFS Server Provisioner is installed

WARNING: Install "nfs-common" package on all MicroK8S nodes to allow Pods with NFS mounts to start: sudo apt update && sudo apt install -y nfs-common
WARNING: NFS Server Provisioner servers by default hostPath storage from a single Node.
```
2. Создать Deployment приложения состоящего из multitool, и подключить к нему PV, созданный автоматически на сервере NFS.
```sh
qwuen@LAPTOP-2QLN04RI:/mnt/c/projects/home/devops-netology/assets/12-kuber-07/manifests$ kubectl apply -f pvc-2.yml -n netology
persistentvolumeclaim/pvc-2 created
qwuen@LAPTOP-2QLN04RI:/mnt/c/projects/home/devops-netology/assets/12-kuber-07/manifests$ kubectl apply -f deployment-2.yml -n netology
deployment.apps/deployment2 created
qwuen@LAPTOP-2QLN04RI:/mnt/c/projects/home/devops-netology/assets/12-kuber-07/manifests$ kubectl get po,pvc,pv -n netology
NAME                               READY   STATUS    RESTARTS   AGE
pod/deployment2-64b5489dcb-p4l9x   1/1     Running   0          28m

NAME                          STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS   AGE
persistentvolumeclaim/pvc-2   Bound    pvc-723248ee-e862-4396-a92e-b8fe212c2ad2   1Gi        RWO            nfs
   28m

NAME                                                        CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM                                                  STORAGECLASS   REASON   AGE
persistentvolume/data-nfs-server-provisioner-0              1Gi        RWO            Retain           Bound    nfs-server-provisioner/data-nfs-server-provisioner-0                           38m
persistentvolume/pvc-723248ee-e862-4396-a92e-b8fe212c2ad2   1Gi        RWO            Delete           Bound    netology/pvc-2                                         nfs                     28m
```
3. Продемонстрировать возможность чтения и записи файла изнутри пода. 
```sh
deployment2-64b5489dcb-p4l9x:/# echo "$(date +'%T %F')" >> /input/input.log
deployment2-64b5489dcb-p4l9x:/# cat /input/input.log
18:53:17 2023-12-24
```
4. Предоставить манифесты, а также скриншоты или вывод необходимых команд.
- [pvc-2.yml](/assets/12-kuber-07/manifests/pvc-2.yml)
- [deployment-2.yml](/assets/12-kuber-07/manifests/deployment-2.yml)