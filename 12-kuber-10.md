# Домашнее задание к занятию «Helm»

### Инструменты и дополнительные материалы, которые пригодятся для выполнения задания

1. [Инструкция](https://helm.sh/docs/intro/install/) по установке Helm. [Helm completion](https://helm.sh/docs/helm/helm_completion/).

------

### Установка Helm
```sh
qwuen@MSI:/mnt/d/projects/devops-netology/assets$ curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
qwuen@MSI:/mnt/d/projects/devops-netology/assets$ chmod 700 get_helm.sh
qwuen@MSI:/mnt/d/projects/devops-netology/assets$ ./get_helm.sh
Downloading https://get.helm.sh/helm-v3.14.0-linux-amd64.tar.gz
Verifying checksum... Done.
Preparing to install helm into /usr/local/bin
[sudo] password for qwuen:
helm installed into /usr/local/bin/helm
qwuen@MSI:/mnt/d/projects/devops-netology/assets$ helm version
version.BuildInfo{Version:"v3.14.0", GitCommit:"3fc9f4b2638e76f26739cd77c7017139be81d0ea", GitTreeState:"clean", GoVersion:"go1.21.5"}
```

### Задание 1. Подготовить Helm-чарт для приложения

1. Необходимо упаковать приложение в чарт для деплоя в разные окружения. 
```sh
qwuen@MSI:/mnt/d/projects/devops-netology/assets$ cd 12-kuber-10/helm/
qwuen@MSI:/mnt/d/projects/devops-netology/assets/12-kuber-10/helm$ helm create mychart
Creating mychart
```
2. Каждый компонент приложения деплоится отдельным deployment’ом или statefulset’ом.
3. В переменных чарта измените образ приложения для изменения версии.

------
### Задание 2. Запустить две версии в разных неймспейсах

1. Подготовив чарт, необходимо его проверить. Запуститe несколько копий приложения.
2. Одну версию в namespace=app1, вторую версию в том же неймспейсе, третью версию в namespace=app2.
3. Продемонстрируйте результат.
```sh
qwuen@MSI:/mnt/d/projects/devops-netology/assets/12-kuber-10/helm$ helm lint mychart
==> Linting mychart
[INFO] Chart.yaml: icon is recommended

1 chart(s) linted, 0 chart(s) failed
```
```sh
qwuen@MSI:/mnt/d/projects/devops-netology/assets/12-kuber-10/helm$ helm upgrade --install --atomic --timeout 180s --debug app-mychart mychart/ --namespace app1 --create-namespace
history.go:56: [debug] getting history for release app-mychart
Release "app-mychart" does not exist. Installing it now.
install.go:214: [debug] Original chart version: ""
install.go:231: [debug] CHART PATH: /mnt/d/projects/devops-netology/assets/12-kuber-10/helm/mychart

client.go:142: [debug] creating 1 resource(s)
client.go:142: [debug] creating 5 resource(s)
wait.go:48: [debug] beginning wait for 5 resources with timeout of 3m0s
ready.go:452: [debug] ReplicaSet is not ready: app1/deployment-2-app-mychart-7474c9bbc. observedGeneration (0) does not match spec generation (1).
ready.go:303: [debug] Deployment is not ready: app1/deployment-2-app-mychart. 0 out of 1 expected pods are ready
NAME: app-mychart
LAST DEPLOYED: Fri Jan 26 17:48:11 2024
NAMESPACE: app1
STATUS: deployed
...

qwuen@MSI:/mnt/d/projects/devops-netology/assets/12-kuber-10/helm$ helm upgrade --install --atomic --timeout 180s --debug app-mychart-2 mychart/ --namespace app1 --create-namespace
history.go:56: [debug] getting history for release app-mychart-2
Release "app-mychart-2" does not exist. Installing it now.
install.go:214: [debug] Original chart version: ""
install.go:231: [debug] CHART PATH: /mnt/d/projects/devops-netology/assets/12-kuber-10/helm/mychart

client.go:142: [debug] creating 1 resource(s)
client.go:142: [debug] creating 5 resource(s)
wait.go:48: [debug] beginning wait for 5 resources with timeout of 3m0s
ready.go:452: [debug] ReplicaSet is not ready: app1/deployment-2-app-mychart-2-5cbc5bfd6c. observedGeneration (0) does not match spec generation (1).
ready.go:303: [debug] Deployment is not ready: app1/deployment-2-app-mychart-2. 0 out of 1 expected pods are ready
NAME: app-mychart-2
LAST DEPLOYED: Fri Jan 26 17:48:26 2024
NAMESPACE: app1
STATUS: deployed
REVISION: 1
...

qwuen@MSI:/mnt/d/projects/devops-netology/assets/12-kuber-10/helm$ helm upgrade --install --atomic --timeout 180s --debug app-mychart-3 mychart/ --namespace app2 --create-namespace
history.go:56: [debug] getting history for release app-mychart-3
Release "app-mychart-3" does not exist. Installing it now.
install.go:214: [debug] Original chart version: ""
install.go:231: [debug] CHART PATH: /mnt/d/projects/devops-netology/assets/12-kuber-10/helm/mychart

client.go:142: [debug] creating 1 resource(s)
client.go:142: [debug] creating 5 resource(s)
wait.go:48: [debug] beginning wait for 5 resources with timeout of 3m0s
ready.go:452: [debug] ReplicaSet is not ready: app2/deployment-2-app-mychart-3-6884469c87. observedGeneration (0) does not match spec generation (1).
ready.go:303: [debug] Deployment is not ready: app2/deployment-2-app-mychart-3. 0 out of 1 expected pods are ready
NAME: app-mychart-3
LAST DEPLOYED: Fri Jan 26 17:48:52 2024
NAMESPACE: app2
STATUS: deployed
```
Список подов и сервисов:  
```sh
qwuen@MSI:/mnt/d/projects/devops-netology/assets/12-kuber-10/helm$ kubectl get po -n app1
NAME                                          READY   STATUS    RESTARTS   AGE
deployment-2-app-mychart-7474c9bbc-hvd9p      1/1     Running   0          76s
app-mychart-747c78fc84-dlrjj                  1/1     Running   0          76s
app-mychart-2-6d89dd9dbf-pxgqk                1/1     Running   0          62s
deployment-2-app-mychart-2-5cbc5bfd6c-x79fd   1/1     Running   0          62s
qwuen@MSI:/mnt/d/projects/devops-netology/assets/12-kuber-10/helm$ kubectl get svc -n app1
NAME                          TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)    AGE
app-mychart                   ClusterIP   10.152.183.23    <none>        80/TCP     101s
svc-multitool-app-mychart     ClusterIP   10.152.183.41    <none>        8080/TCP   101s
svc-multitool-app-mychart-2   ClusterIP   10.152.183.74    <none>        8080/TCP   86s
app-mychart-2                 ClusterIP   10.152.183.227   <none>        80/TCP     86s
qwuen@MSI:/mnt/d/projects/devops-netology/assets/12-kuber-10/helm$ kubectl get po -n app2
NAME                                          READY   STATUS    RESTARTS   AGE
app-mychart-3-75856f6d4-k87ph                 1/1     Running   0          71s
deployment-2-app-mychart-3-6884469c87-bn289   1/1     Running   0          71s
qwuen@MSI:/mnt/d/projects/devops-netology/assets/12-kuber-10/helm$ kubectl get svc -n app2
NAME                          TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)    AGE
svc-multitool-app-mychart-3   ClusterIP   10.152.183.117   <none>        8080/TCP   76s
app-mychart-3                 ClusterIP   10.152.183.32    <none>        80/TCP     76s
qwuen@MSI:/mnt/d/projects/devops-netology/assets/12-kuber-10/helm$
```

Манифесты:
- [deployment-2.yaml](/assets/12-kuber-10/helm/mychart/templates/deployment-2.yaml)
- [service-2.yaml](/assets/12-kuber-10/helm/mychart/templates/service-2.yaml)
- [values.yaml](/assets/12-kuber-10/helm/mychart/values.yaml)
- [Chart.yaml](/assets/12-kuber-10/helm/mychart/Chart.yaml)

#### Специально оставил дефолтный `nginx` и добавил свой `multitool` деплоймент.  