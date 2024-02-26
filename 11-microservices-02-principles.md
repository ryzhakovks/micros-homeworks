
# Домашнее задание к занятию «Микросервисы: принципы»

Вы работаете в крупной компании, которая строит систему на основе микросервисной архитектуры.
Вам как DevOps-специалисту необходимо выдвинуть предложение по организации инфраструктуры для разработки и эксплуатации.

## Задача 1: API Gateway 

<details>
<summary>Задание</summary>

Предложите решение для обеспечения реализации API Gateway. Составьте сравнительную таблицу возможностей различных программных решений. На основе таблицы сделайте выбор решения.

Решение должно соответствовать следующим требованиям:
- маршрутизация запросов к нужному сервису на основе конфигурации,
- возможность проверки аутентификационной информации в запросах,
- обеспечение терминации HTTPS.

</details>

| Продукт | Маршрутизация запросов | Проверка аутентификации | Терминация HTTPS |
|---------|-----------------------|--------------------------|------------------|
| nginx   | Да                    | Да                       | Да               |
| Kong    | Да                    | Да                       | Да               |
| Tyk     | Да                    | Да                       | Да               |
| apisix  | Да                    | Да                       | Да               |
| gravitee  | Да                    | Да                       | Да               |
| wso2  | Да                    | Да                       | Да               |
| Apigee  | Да                    | Да                       | Да               |

Все указанные продукты удовлетворяют требованиям задачи и имеют свои преимущества. Например хорошая производительность как у `gravitee` или `Apigee`, большое сообщество как у `kong` или `nginx`, но при этом есть риски ограничения поддержки в России как например у `Apigee` от Google.

Продукт `nginx` имеет огромную популярность и наверное наибольшее сообщество в России, можно остановиться на нем. При этом есть возможность платной поддержки при необходимости.

----

## Задача 2: Брокер сообщений

<details>
<summary>Задание</summary>

Составьте таблицу возможностей различных брокеров сообщений. На основе таблицы сделайте обоснованный выбор решения.

Решение должно соответствовать следующим требованиям:
- поддержка кластеризации для обеспечения надёжности,
- хранение сообщений на диске в процессе доставки,
- высокая скорость работы,
- поддержка различных форматов сообщений,
- разделение прав доступа к различным потокам сообщений,
- простота эксплуатации.

</details>

| Брокер сообщений | Поддержка кластеризации | Хранение сообщений на диске | Высокая скорость работы | Поддержка различных форматов сообщений | Разделение прав доступа | Простота эксплуатации |
| --- | --- | --- | --- | --- | --- | --- |
| Apache Kafka | + | + | + | + | + | +- |
| RabbitMQ | + | + | + | STOMP, AMQP, MQTT | + | + |
| Redis | + | +- | + | + | + | + |
| ActiveMQ | + | + | + | OpenWire, STOMP, AMQP, MQTT, JMS | + | + |

**Выводы**:  
`Apache Kafka` - является наиболее популярным продуктом с большим сообществом и высокой призводительностью. `Redis` - имеет наибольшую популярность как база данных для хранения `горячих` данных (InMemory database). `RabbitMQ` - простой в использовании, но имеет меньшую гибкость в использовании чем `Apache Kafka`

## Задача 3: API Gateway * (необязательная)

<details>
<summary>Задание</summary>

### Есть три сервиса:

**minio**
- хранит загруженные файлы в бакете images,
- S3 протокол,

**uploader**
- принимает файл, если картинка сжимает и загружает его в minio,
- POST /v1/upload,

**security**
- регистрация пользователя POST /v1/user,
- получение информации о пользователе GET /v1/user,
- логин пользователя POST /v1/token,
- проверка токена GET /v1/token/validation.

### Необходимо воспользоваться любым балансировщиком и сделать API Gateway:

**POST /v1/register**
1. Анонимный доступ.
2. Запрос направляется в сервис security POST /v1/user.

**POST /v1/token**
1. Анонимный доступ.
2. Запрос направляется в сервис security POST /v1/token.

**GET /v1/user**
1. Проверка токена. Токен ожидается в заголовке Authorization. Токен проверяется через вызов сервиса security GET /v1/token/validation/.
2. Запрос направляется в сервис security GET /v1/user.

**POST /v1/upload**
1. Проверка токена. Токен ожидается в заголовке Authorization. Токен проверяется через вызов сервиса security GET /v1/token/validation/.
2. Запрос направляется в сервис uploader POST /v1/upload.

**GET /v1/user/{image}**
1. Проверка токена. Токен ожидается в заголовке Authorization. Токен проверяется через вызов сервиса security GET /v1/token/validation/.
2. Запрос направляется в сервис minio GET /images/{image}.

### Ожидаемый результат

Результатом выполнения задачи должен быть docker compose файл, запустив который можно локально выполнить следующие команды с успешным результатом.
Предполагается, что для реализации API Gateway будет написан конфиг для NGinx или другого балансировщика нагрузки, который будет запущен как сервис через docker-compose и будет обеспечивать балансировку и проверку аутентификации входящих запросов.
Авторизация
curl -X POST -H 'Content-Type: application/json' -d '{"login":"bob", "password":"qwe123"}' http://localhost/token

**Загрузка файла**

curl -X POST -H 'Authorization: Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJib2IifQ.hiMVLmssoTsy1MqbmIoviDeFPvo-nCd92d4UFiN2O2I' -H 'Content-Type: octet/stream' --data-binary @yourfilename.jpg http://localhost/upload

**Получение файла**
curl -X GET http://localhost/images/4e6df220-295e-4231-82bc-45e4b1484430.jpg

---

#### [Дополнительные материалы: как запускать, как тестировать, как проверить](https://github.com/netology-code/devkub-homeworks/tree/main/11-microservices-02-principles)

</details>


## Файлы проекта: 
- [docker-compose.yaml](assets/11-microservices-02-principles/docker-compose.yaml)
- Измененный [requirements.txt](assets/11-microservices-02-principles/security/requirements.txt)
- [nginx.conf](assets/11-microservices-02-principles/gateway/nginx.conf)

## Запуск

```sh
qwuen@LAPTOP-2QLN04RI:/mnt/c/projects/home/devops-netology/assets/11-microservices-02-principles$ docker compose up --build -d 
[+] Running 5/5
 ⠿ Container 11-microservices-02-principles-storage-1        Running                                               0.0s
 ⠿ Container 11-microservices-02-principles-createbuckets-1  Started                                               1.0s
 ⠿ Container 11-microservices-02-principles-uploader-1       Started                                               2.2s
 ⠿ Container 11-microservices-02-principles-security-1       Started                                               0.5s
 ⠿ Container 11-microservices-02-principles-gateway-1        Started                                               3.1s
qwuen@LAPTOP-2QLN04RI:/mnt/c/projects/home/devops-netology/assets/11-microservices-02-principles$ docker ps
CONTAINER ID   IMAGE                                     COMMAND                  CREATED          STATUS                        PORTS                                           NAMES
7e3be6ae81c9   nginx:alpine                              "/docker-entrypoint.…"   15 seconds ago   Up 11 seconds                 80/tcp, 0.0.0.0:80->8080/tcp, :::80->8080/tcp   11-microservices-02-principles-gateway-1
0faa08b79c6d   11-microservices-02-principles_security   "python ./server.py"     15 seconds ago   Up 14 seconds                 3000/tcp                                        11-microservices-02-principles-security-1
f3a2f30a2d88   11-microservices-02-principles_uploader   "docker-entrypoint.s…"   3 hours ago      Up 12 seconds                 3000/tcp                                        11-microservices-02-principles-uploader-1
fed60b204b11   minio/minio:latest                        "/usr/bin/docker-ent…"   3 hours ago      Up About a minute (healthy)   9000/tcp                                        11-microservices-02-principles-storage-1
```

## Получение токена

```sh
qwuen@LAPTOP-2QLN04RI:/mnt/c/projects/home/devops-netology/assets/11-microservices-02-principles$ curl -X POST -H 'Content-Type: application/json' -d '{"login":"bob", "password":"qwe123"}' http://localhost/token
eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJib2IifQ.hiMVLmssoTsy1MqbmIoviDeFPvo-nCd92d4UFiN2O2I
```

## Загрузка картинки

```sh
curl -X POST -H 'Authorization: Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJib2IifQ.hiMVLmssoTsy1MqbmIoviDeFPvo-nCd92d4UFiN2O2I' -H 'Content-Type: octet/stream' --data-binary @test.png http://localhost/upload
```

## Скачать картинку

```sh
qwuen@LAPTOP-2QLN04RI:/mnt/c/projects/home/devops-netology/assets/11-microservices-02-principles$ curl localhost/images/c31e9789-3fab-4689-aa67-e7ac2684fb0e.jpg > c31e9789-3fab-4689-aa67-e7ac2684fb0e.jpg
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   383  100   383    0     0  95750      0 --:--:-- --:--:-- --:--:-- 95750
 
```

## Список файлов

```sh
qwuen@LAPTOP-2QLN04RI:/mnt/c/projects/home/devops-netology/assets/11-microservices-02-principles$ ls -la
total 80
total 80
drwxrwxrwx 1 qwuen qwuen  4096 Oct 19 22:01 .
drwxrwxrwx 1 qwuen qwuen  4096 Oct 18 22:54 ..
-rwxrwxrwx 1 qwuen qwuen    75 Oct 18 22:52 .env
-rwxrwxrwx 1 qwuen qwuen   383 Oct 19 22:01 c31e9789-3fab-4689-aa67-e7ac2684fb0e.jpg
-rwxrwxrwx 1 qwuen qwuen  1731 Oct 18 22:52 docker-compose.yaml
drwxrwxrwx 1 qwuen qwuen  4096 Oct 18 22:54 gateway
-rwxrwxrwx 1 qwuen qwuen  1763 Oct 18 22:52 readme.md
drwxrwxrwx 1 qwuen qwuen  4096 Oct 18 22:54 security
-rwxrwxrwx 1 qwuen qwuen 72629 Oct  4 15:15 test.png
drwxrwxrwx 1 qwuen qwuen  4096 Oct 18 22:54 uploader
```
