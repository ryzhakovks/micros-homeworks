# Домашнее задание к занятию "Troubleshooting"
"Troubleshooting"

### Цель задания

Устранить неисправности при деплое приложения.

### Чеклист готовности к домашнему заданию

1. Кластер k8s.

### Задание. При деплое приложение web-consumer не может подключиться к auth-db. Необходимо это исправить.

1. Установить приложение по команде:
```shell
kubectl apply -f https://raw.githubusercontent.com/netology-code/kuber-homeworks/main/3.5/files/task.yaml
```
2. Выявить проблему и описать.
3. Исправить проблему, описать, что сделано.
4. Продемонстрировать, что проблема решена.

#### Решение

При запуске kubectl apply -f https://raw.githubusercontent.com/netology-code/kuber-homeworks/main/3.5/files/task.yaml пишет, что не может создать `Deployment` по причине отсутствия 
`namespace` = web, data

Создаем их 

```bash
$ kubectl get namespace
NAME              STATUS   AGE
kube-system       Active   81d
kube-public       Active   81d
kube-node-lease   Active   81d
default           Active   81d
ingress           Active   68d
web               Active   28h
data              Active   28h
```

Далее файл yaml отрабатывает. Создается 2 пода(с помощью ReplicaSet) в namespace=web и под и сервис в namespace=data
```bash
$ kubectl get pod -n web
NAME                            READY   STATUS    RESTARTS        AGE
web-consumer-577d47b97d-zb4sc   1/1     Running   1 (6h25m ago)   28h
web-consumer-577d47b97d-5gbpj   1/1     Running   1 (6h25m ago)   28h
```

```bash
$ kubectl get all -n data
NAME                           READY   STATUS    RESTARTS        AGE
pod/auth-db-795c96cddc-k586q   1/1     Running   1 (6h26m ago)   28h

NAME              TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)   AGE
service/auth-db   ClusterIP   10.152.183.29   <none>        80/TCP    28h

NAME                      READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/auth-db   1/1     1            1           28h

NAME                                 DESIRED   CURRENT   READY   AGE
replicaset.apps/auth-db-795c96cddc   1         1         1       28h
```

Контейнер busybox(внутри подов web-consumer-....) пытается обратится к сущности auth-db(do curl auth-db;)

```bash
$ kubectl logs pod/web-consumer-577d47b97d-5gbpj -n web
curl: (6) Couldn't resolve host 'auth-db'
curl: (6) Couldn't resolve host 'auth-db'
curl: (6) Couldn't resolve host 'auth-db'
curl: (6) Couldn't resolve host 'auth-db'
curl: (6) Couldn't resolve host 'auth-db'
curl: (6) Couldn't resolve host 'auth-db'
curl: (6) Couldn't resolve host 'auth-db'
curl: (6) Couldn't resolve host 'auth-db'
curl: (6) Couldn't resolve host 'auth-db'
```

хост не знает такого dns имени auth-db

Зайдем в контейнер, проверим есть ли доступ к приложению через ip-адрес сервиса(10.152.183.29)
```bash
$ kubectl exec -it pod/web-consumer-577d47b97d-5gbpj -n web -c busybox -- bin/sh
[ root@web-consumer-577d47b97d-5gbpj:/ ]$ curl 10.152.183.29
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

Видим что проблема заключается конкретно, что контейнер не знает имя auth-db

Я пробовал разные варианты(пытался связать через лейблы в сервисах или через ингресс), но единственное к чему пришел
что нужно либо днс сервер(где содержится данное имя) привязать к контейнеру либо добавить в ручную в каждый контейнер.

```bash
[ root@web-consumer-577d47b97d-5gbpj:/ ]$ cat etc/hosts
# Kubernetes-managed hosts file.
127.0.0.1       localhost
::1     localhost ip6-localhost ip6-loopback
fe00::0 ip6-localnet
fe00::0 ip6-mcastprefix
fe00::1 ip6-allnodes
fe00::2 ip6-allrouters
10.1.128.205    web-consumer-577d47b97d-5gbpj
10.152.183.29   auth-db
```

```bash
[ root@web-consumer-577d47b97d-5gbpj:/ ]$ curl auth-db
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

```bash
$ kubectl logs web-consumer-577d47b97d-5gbpj -n web
curl: (6) Couldn't resolve host 'auth-db'
curl: (6) Couldn't resolve host 'auth-db'
curl: (6) Couldn't resolve host 'auth-db'
curl: (6) Couldn't resolve host 'auth-db'
curl: (6) Couldn't resolve host 'auth-db'
curl: (6) Couldn't resolve host 'auth-db'
curl: (6) Couldn't resolve host 'auth-db'
curl: (6) Couldn't resolve host 'auth-db'
curl: (6) Couldn't resolve host 'auth-db'

curl: (6) Couldn't resolve host 'auth-db'
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
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
100   612  100   612    0     0   954k      0 --:--:-- --:--:-- --:--:--  597k
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   612  100   612    0     0  1134k      0 --:--:-- --:--:-- --:--:--  597k
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
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
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
100   612  100   612    0     0   774k      0 --:--:-- --:--:-- --:--:--  597k
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
```

В общем решение рабочее, но скажем только для этого теста пойдет.

Просьба подсказать хороший/правильный/наилучший вариант для решения данной проблемы.




### Правила приема работы

1. Домашняя работа оформляется в своем Git репозитории в файле README.md. Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.
2. Файл README.md должен содержать скриншоты вывода необходимых команд, а также скриншоты результатов
3. Репозиторий должен содержать тексты манифестов или ссылки на них в файле README.md
