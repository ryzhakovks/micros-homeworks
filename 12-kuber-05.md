# Домашнее задание к занятию «Сетевое взаимодействие в K8S. Часть 2»

### Инструменты и дополнительные материалы, которые пригодятся для выполнения задания

1. [Инструкция](https://microk8s.io/docs/getting-started) по установке MicroK8S.
2. [Описание](https://kubernetes.io/docs/concepts/services-networking/service/) Service.
3. [Описание](https://kubernetes.io/docs/concepts/services-networking/ingress/) Ingress.
4. [Описание](https://github.com/wbitt/Network-MultiTool) Multitool.

------

### Задание 1. Создать Deployment приложений backend и frontend

1. Создать Deployment приложения _frontend_ из образа nginx с количеством реплик 3 шт.
2. Создать Deployment приложения _backend_ из образа multitool. 
3. Добавить Service, которые обеспечат доступ к обоим приложениям внутри кластера. 
```sh 
qwuen@LAPTOP-2QLN04RI:/mnt/c/projects/home/devops-netology/assets/12-kuber-05/manifests$ k apply -f frontend-deployment.yml -n netology
deployment.apps/frontend-deployment created
service/frontend-svc created
qwuen@LAPTOP-2QLN04RI:/mnt/c/projects/home/devops-netology/assets/12-kuber-05/manifests$ k apply -f backend-deployment.yml -n netology
deployment.apps/backend-deployment created
service/backend-svc created
qwuen@LAPTOP-2QLN04RI:/mnt/c/projects/home/devops-netology/assets/12-kuber-05/manifests$ k get po -n netology
NAME                                  READY   STATUS    RESTARTS   AGE
frontend-deployment-d9c659cb5-czpvv   1/1     Running   0          18m
frontend-deployment-d9c659cb5-x6pss   1/1     Running   0          18m
frontend-deployment-d9c659cb5-jrftr   1/1     Running   0          18m
backend-deployment-84b946b655-t8dgw   1/1     Running   0          9s
backend-deployment-84b946b655-ld4pn   1/1     Running   0          7s
backend-deployment-84b946b655-796lx   1/1     Running   0          5s
```
4. Продемонстрировать, что приложения видят друг друга с помощью Service.
5. Предоставить манифесты Deployment и Service в решении, а также скриншоты или вывод команды п.4.
```sh
qwuen@LAPTOP-2QLN04RI:/mnt/c/projects/home/devops-netology/assets/12-kuber-05/manifests$ k exec -it frontend-deployment-d9c659cb5-czpvv -n netology -- bash
root@frontend-deployment-d9c659cb5-czpvv:/# curl backend-svc.netology
WBITT Network MultiTool (with NGINX) - backend-deployment-84b946b655-t8dgw - 10.1.106.177 - HTTP: 8080 , HTTPS: 443 . (Formerly praqma/network-multitool)


qwuen@LAPTOP-2QLN04RI:/mnt/c/projects/home/devops-netology/assets/12-kuber-05/manifests$ k exec -it backend-deployment-84b946b655-t8dgw -n netology -- bash
backend-deployment-84b946b655-t8dgw:/# curl frontend-svc
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

### Манифесты:   
- [frontend-deployment.yml](/assets/12-kuber-05/manifests/frontend-deployment.yml)
- [backend-deployment.yml](/assets/12-kuber-05/manifests/backend-deployment.yml)

------

### Задание 2. Создать Ingress и обеспечить доступ к приложениям снаружи кластера

1. Включить Ingress-controller в MicroK8S.
2. Создать Ingress, обеспечивающий доступ снаружи по IP-адресу кластера MicroK8S так, чтобы при запросе только по адресу открывался _frontend_ а при добавлении /api - _backend_.
3. Продемонстрировать доступ с помощью браузера или `curl` с локального компьютера.
4. Предоставить манифесты и скриншоты или вывод команды п.2.

```sh
qwuen@LAPTOP-2QLN04RI:/mnt/c/projects/home/devops-netology/assets/12-kuber-05/manifests$ k apply -f ingress-app.yml -n n
etology
ingress.networking.k8s.io/app created

qwuen@LAPTOP-2QLN04RI:/mnt/c/projects/home/devops-netology/assets/12-kuber-05/manifests$ curl -H "Host: app.com" 192.168
.56.10
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

qwuen@LAPTOP-2QLN04RI:/mnt/c/projects/home/devops-netology/assets/12-kuber-05/manifests$ curl -H "Host: app.com" 192.168.56.10/api
WBITT Network MultiTool (with NGINX) - backend-deployment-84b946b655-ld4pn - 10.1.106.178 - HTTP: 8080 , HTTPS: 443 . (Formerly praqma/network-multitool)
```

### Манифесты:  
- [ingress-app.yml](/assets/12-kuber-05/manifests/ingress-app.yml)

------