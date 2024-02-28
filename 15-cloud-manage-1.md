# Домашнее задание к занятию «Организация сети»

### Задание 1. Yandex Cloud 

**Что нужно сделать**

1. Создать пустую VPC. Выбрать зону.
2. Публичная подсеть.

 - Создать в VPC subnet с названием public, сетью 192.168.10.0/24.
 - Создать в этой подсети NAT-инстанс, присвоив ему адрес 192.168.10.254. В качестве image_id использовать fd80mrhj8fl2oe87o4e1.
 - Создать в этой публичной подсети виртуалку с публичным IP, подключиться к ней и убедиться, что есть доступ к интернету.
3. Приватная подсеть.
 - Создать в VPC subnet с названием private, сетью 192.168.20.0/24.
 - Создать route table. Добавить статический маршрут, направляющий весь исходящий трафик private сети в NAT-инстанс.
 - Создать в этой приватной подсети виртуалку с внутренним IP, подключиться к ней через виртуалку, созданную ранее, и убедиться, что есть доступ к интернету.

Resource Terraform для Yandex Cloud:

- [VPC subnet](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/vpc_subnet).
- [Route table](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/vpc_route_table).
- [Compute Instance](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/compute_instance).


Листинг команд:
```sh
D:\projects\devops-netology\assets\15-cloud-manage-1\terraform>terraform apply
data.yandex_compute_image.ubuntu: Reading...
yandex_vpc_network.base_network: Refreshing state... [id=enp5v8tmope9mmgp5oiq]
data.yandex_compute_image.ubuntu: Read complete after 1s [id=fd82qs98ootbak6lkmmj]
yandex_vpc_subnet.public: Refreshing state... [id=e9b2h3rjivpe0jq3qoks]
yandex_compute_instance.public_instance: Refreshing state... [id=fhm9igglfr83jtrlpbbp]
yandex_vpc_route_table.private_route: Refreshing state... [id=enp4p645d0nol550fns7]

Outputs:

private = "private-instance - 10.0.2.4()"
public = "public-instance - 10.0.1.6(158.160.40.112)"
```
Тест соединений публичной ВМ (10.0.1.6(158.160.40.112)):
```sh
C:\Users\itsid>ssh ubuntu@158.160.40.112
The authenticity of host '158.160.40.112 (158.160.40.112)' can't be established.
ECDSA key fingerprint is SHA256:Dj7nnM+5eiaO8XOTHKEQmWMKvdr/6fQOwzh3ga2oDho.
ubuntu@public-instance:~$ ping 8.8.8.8
PING 8.8.8.8 (8.8.8.8) 56(84) bytes of data.
64 bytes from 8.8.8.8: icmp_seq=1 ttl=58 time=20.0 ms
64 bytes from 8.8.8.8: icmp_seq=2 ttl=58 time=19.2 ms
64 bytes from 8.8.8.8: icmp_seq=3 ttl=58 time=19.3 ms
^C
--- 8.8.8.8 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2002ms
rtt min/avg/max/mdev = 19.281/19.556/20.036/0.359 ms
ubuntu@public-instance:~$ ping 10.0.2.4
PING 10.0.2.4 (10.0.2.4) 56(84) bytes of data.
64 bytes from 10.0.2.4: icmp_seq=1 ttl=61 time=1.57 ms
64 bytes from 10.0.2.4: icmp_seq=2 ttl=61 time=0.746 ms
64 bytes from 10.0.2.4: icmp_seq=3 ttl=61 time=0.606 ms
64 bytes from 10.0.2.4: icmp_seq=4 ttl=61 time=0.595 ms
^C
--- 10.0.2.4 ping statistics ---
4 packets transmitted, 4 received, 0% packet loss, time 3036ms
rtt min/avg/max/mdev = 0.595/0.879/1.570/0.403 ms

```

Тест соединений приватной ВМ (10.0.2.4)
```sh
ubuntu@public-instance:~$ sudo chmod 700 .ssh/id_rsa
ubuntu@public-instance:~$ ssh ubuntu@10.0.2.4
ubuntu@private-instance:~$ ping 8.8.8.8
PING 8.8.8.8 (8.8.8.8) 56(84) bytes of data.
64 bytes from 8.8.8.8: icmp_seq=1 ttl=54 time=20.8 ms
64 bytes from 8.8.8.8: icmp_seq=2 ttl=54 time=19.9 ms
64 bytes from 8.8.8.8: icmp_seq=3 ttl=54 time=19.8 ms
^C
--- 8.8.8.8 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2002ms
rtt min/avg/max/mdev = 19.851/20.227/20.836/0.434 ms
ubuntu@private-instance:~$ ping 10.0.1.6
PING 10.0.1.6 (10.0.1.6) 56(84) bytes of data.
64 bytes from 10.0.1.6: icmp_seq=1 ttl=61 time=0.586 ms
64 bytes from 10.0.1.6: icmp_seq=2 ttl=61 time=0.611 ms
64 bytes from 10.0.1.6: icmp_seq=3 ttl=61 time=0.800 ms
^C
--- 10.0.1.6 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2036ms
rtt min/avg/max/mdev = 0.586/0.665/0.800/0.100 ms
```

Листинг traceroute:
```sh
ubuntu@private-instance:~$ traceroute 8.8.8.8
traceroute to 8.8.8.8 (8.8.8.8), 30 hops max, 60 byte packets
 1  _gateway (10.0.2.1)  0.930 ms  0.882 ms  0.873 ms
 2  * * *
 3  public-instance.ru-central1.internal (10.0.1.6)  1.463 ms  1.912 ms  1.414 ms
 4  public-instance.ru-central1.internal (10.0.1.6)  1.393 ms  1.371 ms  1.794 ms
 5  * * *
 6  * * 178.170.222.224 (178.170.222.224)  5.304 ms
 7  * * 178.170.222.224 (178.170.222.224)  5.411 ms
 8  * * *
 9  178.18.227.7.ix.dataix.eu (178.18.227.7)  11.802 ms  18.924 ms google1.msk.piter-ix.net (185.0.13.212)  18.673 ms
10  * 108.170.250.146 (108.170.250.146)  4.186 ms 74.125.244.180 (74.125.244.180)  18.341 ms
11  142.250.238.214 (142.250.238.214)  20.280 ms 142.251.49.24 (142.251.49.24)  20.579 ms 108.170.227.90 (108.170.227.90)  4.207 ms
12  142.250.208.23 (142.250.208.23)  19.778 ms 142.250.238.181 (142.250.238.181)  19.709 ms 142.251.238.70 (142.251.238.70)  22.633 ms
13  * 142.250.233.27 (142.250.233.27)  22.067 ms 142.250.238.214 (142.250.238.214)  25.422 ms
14  * 216.239.48.224 (216.239.48.224)  19.942 ms *
15  172.253.64.113 (172.253.64.113)  17.451 ms 216.239.46.139 (216.239.46.139)  16.873 ms 108.170.233.163 (108.170.233.163)  21.559 ms
16  * * *
17  * * *
18  * * *
19  * * *
20  * * *
21  * * *
22  * * *
23  dns.google (8.8.8.8)  18.743 ms * *
```

---
### Задание 2. AWS* (задание со звёздочкой)

Это необязательное задание. Его выполнение не влияет на получение зачёта по домашней работе.

**Что нужно сделать**

1. Создать пустую VPC с подсетью 10.10.0.0/16.
2. Публичная подсеть.

 - Создать в VPC subnet с названием public, сетью 10.10.1.0/24.
 - Разрешить в этой subnet присвоение public IP по-умолчанию.
 - Создать Internet gateway.
 - Добавить в таблицу маршрутизации маршрут, направляющий весь исходящий трафик в Internet gateway.
 - Создать security group с разрешающими правилами на SSH и ICMP. Привязать эту security group на все, создаваемые в этом ДЗ, виртуалки.
 - Создать в этой подсети виртуалку и убедиться, что инстанс имеет публичный IP. Подключиться к ней, убедиться, что есть доступ к интернету.
 - Добавить NAT gateway в public subnet.
3. Приватная подсеть.
 - Создать в VPC subnet с названием private, сетью 10.10.2.0/24.
 - Создать отдельную таблицу маршрутизации и привязать её к private подсети.
 - Добавить Route, направляющий весь исходящий трафик private сети в NAT.
 - Создать виртуалку в приватной сети.
 - Подключиться к ней по SSH по приватному IP через виртуалку, созданную ранее в публичной подсети, и убедиться, что с виртуалки есть выход в интернет.

Resource Terraform:

1. [VPC](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc).
1. [Subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet).
1. [Internet Gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway).

