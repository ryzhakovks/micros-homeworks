# Домашнее задание к занятию «Сетевое взаимодействие в K8S. Часть 1»

### Инструменты и дополнительные материалы, которые пригодятся для выполнения задания

1. [Описание](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/) Deployment и примеры манифестов.
2. [Описание](https://kubernetes.io/docs/concepts/services-networking/service/) Описание Service.
3. [Описание](https://github.com/wbitt/Network-MultiTool) Multitool.

------

### Задание 1. Создать Deployment и обеспечить доступ к контейнерам приложения по разным портам из другого Pod внутри кластера

1. Создать Deployment приложения, состоящего из двух контейнеров (nginx и multitool), с количеством реплик 3 шт.
```bash
qwuen@LAPTOP-2QLN04RI:/mnt/c/projects/home/devops-netology/assets/12-kuber-04/manifests$ kubectl apply -f ng-multi-deployment.yml -n netology
deployment.apps/ng-multi-deployment created
qwuen@LAPTOP-2QLN04RI:/mnt/c/projects/home/devops-netology/assets/12-kuber-04/manifests$ kubectl get po -n netology
NAME                                   READY   STATUS    RESTARTS   AGE
ng-multi-deployment-5ff6f756d4-7455n   2/2     Running   0          12s
ng-multi-deployment-5ff6f756d4-9sk9k   2/2     Running   0          12s
ng-multi-deployment-5ff6f756d4-v48kr   2/2     Running   0          12s
```
2. Создать Service, который обеспечит доступ внутри кластера до контейнеров приложения из п.1 по порту 9001 — nginx 80, по 9002 — multitool 8080.
```bash
qwuen@LAPTOP-2QLN04RI:/mnt/c/projects/home/devops-netology/assets/12-kuber-04/manifests$ kubectl apply -f ng-multi-service.yml -n netology
service/ng-multi-svc created
qwuen@LAPTOP-2QLN04RI:/mnt/c/projects/home/devops-netology/assets/12-kuber-04/manifests$ kubectl get svc -n netology
NAME           TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)             AGE
ng-multi-svc   ClusterIP   10.106.58.210   <none>        9001/TCP,9002/TCP   20s
```
3. Создать отдельный Pod с приложением multitool и убедиться с помощью `curl`, что из пода есть доступ до приложения из п.1 по разным портам в разные контейнеры.
4. Продемонстрировать доступ с помощью `curl` по доменному имени сервиса.
```bash
qwuen@LAPTOP-2QLN04RI:/mnt/c/projects/home/devops-netology/assets/12-kuber-04/manifests$ kubectl run multitool --image=wbitt/network-multitool -it --rm -- sh
If you don't see a command prompt, try pressing enter.
/ # curl ng-multi-svc.netology:9001
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
/ #
```
5. Предоставить манифесты Deployment и Service в решении, а также скриншоты или вывод команды п.4.

Манифесты:  
- [ng-multi-deployment.yml](/assets/12-kuber-04/manifests/ng-multi-deployment.yml)
- [ng-multi-service.yml](/assets/12-kuber-04/manifests/ng-multi-service.yml)

------

### Задание 2. Создать Service и обеспечить доступ к приложениям снаружи кластера

1. Создать отдельный Service приложения из Задания 1 с возможностью доступа снаружи кластера к nginx, используя тип NodePort.
2. Продемонстрировать доступ с помощью браузера или `curl` с локального компьютера.
3. Предоставить манифест и Service в решении, а также скриншоты или вывод команды п.2.

```sh
qwuen@LAPTOP-2QLN04RI:/mnt/c/projects/home/devops-netology/assets/12-kuber-04/manifests$ kubectl apply -f ng-multi-deployment.yml -n netology
deployment.apps/ng-multi-deployment created
qwuen@LAPTOP-2QLN04RI:/mnt/c/projects/home/devops-netology/assets/12-kuber-04/manifests$ kubectl apply -f ng-nodeport-service.yml -n netology
service/nginx-node created
qwuen@LAPTOP-2QLN04RI:/mnt/c/projects/home/devops-netology/assets/12-kuber-04/manifests$ curl 192.168.56.10:30080
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

Манифесты:  
- [ng-multi-deployment.yml](/assets/12-kuber-04/manifests/ng-multi-deployment.yml)
- [ng-nodeport-service.yml](/assets/12-kuber-04/manifests/ng-nodeport-service.yml)