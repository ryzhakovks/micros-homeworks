# Домашнее задание к занятию «Запуск приложений в K8S»

### Инструменты и дополнительные материалы, которые пригодятся для выполнения задания

1. [Описание](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/) Deployment и примеры манифестов.
2. [Описание](https://kubernetes.io/docs/concepts/workloads/pods/init-containers/) Init-контейнеров.
3. [Описание](https://github.com/wbitt/Network-MultiTool) Multitool.

------

### Задание 1. Создать Deployment и обеспечить доступ к репликам приложения из другого Pod

Манифесты:
- [deployment.yml](/assets/12-kuber-03/deployment.yml)
- [nginx-service.yml](/assets/12-kuber-03/nginx-service.yml)

1. Создать Deployment приложения, состоящего из двух контейнеров — nginx и multitool. Решить возникшую ошибку.
``` sh
qwuen@LAPTOP-2QLN04RI:/mnt/c/projects/home/devops-netology/assets/12-kuber-03$ kubectl apply -f deployment.yml
deployment.apps/nginx-deployment created
qwuen@LAPTOP-2QLN04RI:/mnt/c/projects/home/devops-netology/assets/12-kuber-03$ kubectl get po
NAME                                READY   STATUS    RESTARTS   AGE
nginx-deployment-86b8cf8d84-mtp2n   2/2     Running   0          49s
```
2. После запуска увеличить количество реплик работающего приложения до 2.
```sh
qwuen@LAPTOP-2QLN04RI:/mnt/c/projects/home/devops-netology/assets/12-kuber-03$ kubectl apply -f deployment.yml
deployment.apps/nginx-deployment configured
qwuen@LAPTOP-2QLN04RI:/mnt/c/projects/home/devops-netology/assets/12-kuber-03$ kubectl get po
NAME                                READY   STATUS    RESTARTS   AGE
nginx-deployment-86b8cf8d84-4kqhd   2/2     Running   0          4s
nginx-deployment-86b8cf8d84-mtp2n   2/2     Running   0          2m47s
```
3. Продемонстрировать количество подов до и после масштабирования.
4. Создать Service, который обеспечит доступ до реплик приложений из п.1.
```sh
qwuen@LAPTOP-2QLN04RI:/mnt/c/projects/home/devops-netology/assets/12-kuber-03$ kubectl apply -f nginx-service.yml
service/nginx-service created
qwuen@LAPTOP-2QLN04RI:/mnt/c/projects/home/devops-netology/assets/12-kuber-03$ kubectl get services
NAME            TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)   AGE
kubernetes      ClusterIP   10.96.0.1      <none>        443/TCP   8d
nginx-service   ClusterIP   10.96.71.106   <none>        80/TCP    11s
```
5. Создать отдельный Pod с приложением multitool и убедиться с помощью `curl`, что из пода есть доступ до приложений из п.1.
```sh
qwuen@LAPTOP-2QLN04RI:/mnt/c/projects/home/devops-netology/assets/12-kuber-03$ kubectl run multitool --image=wbitt/network-multitool --restart=Never
pod/multitool created
qwuen@LAPTOP-2QLN04RI:/mnt/c/projects/home/devops-netology/assets/12-kuber-03$ kubectl get po
NAME                                READY   STATUS    RESTARTS   AGE
multitool                           1/1     Running   0          14s
nginx-deployment-86b8cf8d84-4kqhd   2/2     Running   0          6m21s
nginx-deployment-86b8cf8d84-mtp2n   2/2     Running   0          9m4s
qwuen@LAPTOP-2QLN04RI:/mnt/c/projects/home/devops-netology/assets/12-kuber-03$ kubectl exec -it multitool -- curl nginx-
service
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
    body {
        width: 35em;
        margin: 0 auto;
        font-family: Tahoma, Verdana, Arial, sans-serif;
    }
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

В интерактивном режиме:  
```sh
qwuen@LAPTOP-2QLN04RI:/mnt/c/projects/home/devops-netology/assets/12-kuber-03$ kubectl run multitool --image=wbitt/network-multitool -it --rm -- sh
If you don't see a command prompt, try pressing enter.
/ # curl nginx-service
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
    body {
        width: 35em;
        margin: 0 auto;
        font-family: Tahoma, Verdana, Arial, sans-serif;
    }
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
/ # exit
Session ended, resume using 'kubectl attach multitool -c multitool -i -t' command when the pod is running
pod "multitool" deleted
qwuen@LAPTOP-2QLN04RI:/mnt/c/projects/home/devops-netology/assets/12-kuber-03$ kubectl get po
NAME                                READY   STATUS    RESTARTS   AGE
nginx-deployment-86b8cf8d84-4kqhd   2/2     Running   0          14h
nginx-deployment-86b8cf8d84-mtp2n   2/2     Running   0          14h
```

------

### Задание 2. Создать Deployment и обеспечить старт основного контейнера при выполнении условий

Манифесты:
- [deployment-deps.yml](/assets/12-kuber-03/deployment-deps.yml)
- [nginx-service.yml](/assets/12-kuber-03/nginx-service.yml)

1. Создать Deployment приложения nginx и обеспечить старт контейнера только после того, как будет запущен сервис этого приложения.
2. Убедиться, что nginx не стартует. В качестве Init-контейнера взять busybox.
3. Создать и запустить Service. Убедиться, что Init запустился.
4. Продемонстрировать состояние пода до и после запуска сервиса.
```sh
qwuen@LAPTOP-2QLN04RI:/mnt/c/projects/home/devops-netology/assets/12-kuber-03$ kubectl apply -f deployment-deps.yml
deployment.apps/nginx-deployment created
qwuen@LAPTOP-2QLN04RI:/mnt/c/projects/home/devops-netology/assets/12-kuber-03$ kubectl get po
NAME                               READY   STATUS     RESTARTS   AGE
nginx-deployment-77fc56859-vbshz   0/1     Init:0/1   0          9s
qwuen@LAPTOP-2QLN04RI:/mnt/c/projects/home/devops-netology/assets/12-kuber-03$ kubectl apply -f nginx-service.yml
service/nginx-service created
qwuen@LAPTOP-2QLN04RI:/mnt/c/projects/home/devops-netology/assets/12-kuber-03$ kubectl get po
NAME                               READY   STATUS     RESTARTS   AGE
nginx-deployment-77fc56859-vbshz   0/1     Init:0/1   0          3m4s
qwuen@LAPTOP-2QLN04RI:/mnt/c/projects/home/devops-netology/assets/12-kuber-03$ kubectl get po
NAME                               READY   STATUS            RESTARTS   AGE
nginx-deployment-77fc56859-vbshz   0/1     PodInitializing   0          3m43s
qwuen@LAPTOP-2QLN04RI:/mnt/c/projects/home/devops-netology/assets/12-kuber-03$ kubectl get po
NAME                               READY   STATUS    RESTARTS   AGE
nginx-deployment-77fc56859-vbshz   1/1     Running   0          3m54s
```

------