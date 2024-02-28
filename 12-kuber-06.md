# Домашнее задание к занятию «Хранение в K8s. Часть 1»

### Дополнительные материалы для выполнения задания

1. [Инструкция по установке MicroK8S](https://microk8s.io/docs/getting-started).
2. [Описание Volumes](https://kubernetes.io/docs/concepts/storage/volumes/).
3. [Описание Multitool](https://github.com/wbitt/Network-MultiTool).

------

### Задание 1 

**Что нужно сделать**

Создать Deployment приложения, состоящего из двух контейнеров и обменивающихся данными.

1. Создать Deployment приложения, состоящего из контейнеров busybox и multitool.
2. Сделать так, чтобы busybox писал каждые пять секунд в некий файл в общей директории.
3. Обеспечить возможность чтения файла контейнером multitool.
4. Продемонстрировать, что multitool может читать файл, который периодоически обновляется.
5. Предоставить манифесты Deployment в решении, а также скриншоты или вывод команды из п. 4.

```sh 
qwuen@LAPTOP-2QLN04RI:/mnt/c/projects/home/devops-netology/assets/12-kuber-06$ kubectl apply -f deployment-1.yml -n netology
deployment.apps/empty-dir-example created
qwuen@LAPTOP-2QLN04RI:/mnt/c/projects/home/devops-netology/assets/12-kuber-06$ kubectl get po -n netology
NAME                                 READY   STATUS    RESTARTS   AGE
empty-dir-example-6788bbb88c-sspmr   2/2     Running   0          19s
qwuen@LAPTOP-2QLN04RI:/mnt/c/projects/home/devops-netology/assets/12-kuber-06$ kubectl exec -it empty-dir-example-6788bb
b88c-sspmr multitool --container multitool -n netology -- sh
/ # cat /logs/app.log
11:25:55 2023-12-23
11:26:00 2023-12-23
11:26:05 2023-12-23
11:26:10 2023-12-23
11:26:15 2023-12-23
11:26:20 2023-12-23
```

Манифест:  
- [deployment-1.yml](/assets/12-kuber-06/deployment-1.yml)

------

### Задание 2

**Что нужно сделать**

Создать DaemonSet приложения, которое может прочитать логи ноды.

1. Создать DaemonSet приложения, состоящего из multitool.
2. Обеспечить возможность чтения файла `/var/log/syslog` кластера MicroK8S.
3. Продемонстрировать возможность чтения файла изнутри пода.
4. Предоставить манифесты Deployment, а также скриншоты или вывод команды из п. 2.
```sh
qwuen@LAPTOP-2QLN04RI:/mnt/c/projects/home/devops-netology/assets/12-kuber-06$ kubectl apply -f daemonset.yml -n netolog
y
daemonset.apps/read-log created
qwuen@LAPTOP-2QLN04RI:/mnt/c/projects/home/devops-netology/assets/12-kuber-06$ kubectl get po -n netology
NAME                                 READY   STATUS    RESTARTS   AGE
empty-dir-example-6788bbb88c-sspmr   2/2     Running   0          23m
read-log-69qpk                       1/1     Running   0          17s
qwuen@LAPTOP-2QLN04RI:/mnt/c/projects/home/devops-netology/assets/12-kuber-06$ kubectl exec -it read-log-69qpk -n netolo
gy -- sh
/ # tail -20 /var/log/syslog
Dec 23 11:49:57 kuber microk8s.daemon-kubelite[3956]: I1223 11:49:57.995705    3956 handler.go:232] Adding GroupVersion metrics.k8s.io v1beta1 to ResourceManager
Dec 23 11:49:58 kuber microk8s.daemon-kubelite[3956]: I1223 11:49:58.357941    3956 handler.go:232] Adding GroupVersion crd.projectcalico.org v1 to ResourceManager
Dec 23 11:49:58 kuber microk8s.daemon-kubelite[3956]: I1223 11:49:58.359586    3956 handler.go:232] Adding GroupVersion crd.projectcalico.org v1 to ResourceManager
Dec 23 11:49:58 kuber microk8s.daemon-kubelite[3956]: I1223 11:49:58.361267    3956 handler.go:232] Adding GroupVersion crd.projectcalico.org v1 to ResourceManager
Dec 23 11:49:58 kuber microk8s.daemon-kubelite[3956]: I1223 11:49:58.993012    3956 handler.go:232] Adding GroupVersion metrics.k8s.io v1beta1 to ResourceManager
Dec 23 11:50:02 kuber systemd[1]: run-containerd-runc-k8s.io-f979f34bd15dba44fe09c074ce2bd959be46e0a23e48d0693e8f3d73a80ed032-runc.SvuSDb.mount: Succeeded.
```

Манифест:  
- [daemonset.yml](/assets/12-kuber-06/daemonset.yml)