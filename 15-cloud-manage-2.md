# Домашнее задание к занятию «Вычислительные мощности. Балансировщики нагрузки»  

---
## Задание 1. Yandex Cloud 

**Что нужно сделать**

1. Создать бакет Object Storage и разместить в нём файл с картинкой:

 - Создать бакет в Object Storage с произвольным именем (например, _имя_студента_дата_).
 - Положить в бакет файл с картинкой.
 - Сделать файл доступным из интернета.
 
[Ссылка на файл object-storage.tf](/assets/15-cloud-manage-2/terraform/object-storage.tf)  

2. Создать группу ВМ в public подсети фиксированного размера с шаблоном LAMP и веб-страницей, содержащей ссылку на картинку из бакета:

 - Создать Instance Group с тремя ВМ и шаблоном LAMP. Для LAMP рекомендуется использовать `image_id = fd827b91d99psvq5fjit`.
 - Для создания стартовой веб-страницы рекомендуется использовать раздел `user_data` в [meta_data](https://cloud.yandex.ru/docs/compute/concepts/vm-metadata).
 - Разместить в стартовой веб-странице шаблонной ВМ ссылку на картинку из бакета.
 - Настроить проверку состояния ВМ.
 
[Ссылка на файл vm.tf](/assets/15-cloud-manage-2/terraform/vm.tf)  
[Ссылка на файл locals.tf](/assets/15-cloud-manage-2/terraform/locals.tf)  

3. Подключить группу к сетевому балансировщику:

 - Создать сетевой балансировщик.
 - Проверить работоспособность, удалив одну или несколько ВМ.

[Ссылка на файл main.tf](/assets/15-cloud-manage-2/terraform/main.tf)  

Листинг команд:  
```sh
D:\projects\devops-netology\assets\15-cloud-manage-2\terraform>terraform apply
yandex_vpc_network.my_network: Creating...
yandex_storage_bucket.my_bucket_qazwsx: Creating...
yandex_vpc_network.my_network: Creation complete after 4s [id=enp0ddkj24j5o24pgbhq]
yandex_vpc_subnet.my_subnet: Creating...
yandex_storage_bucket.my_bucket_qazwsx: Creation complete after 5s [id=my-bucket-qazwsx]
yandex_storage_object.content_bg: Creating...
yandex_vpc_subnet.my_subnet: Creation complete after 1s [id=e9brq13nbchqlracruph]
yandex_storage_object.content_bg: Creation complete after 0s [id=test-img.jpg]
yandex_compute_instance_group.my_instance_group: Creating...
yandex_compute_instance_group.my_instance_group: Still creating... [10s elapsed]
yandex_compute_instance_group.my_instance_group: Still creating... [20s elapsed]
yandex_compute_instance_group.my_instance_group: Still creating... [30s elapsed]
yandex_compute_instance_group.my_instance_group: Still creating... [40s elapsed]
yandex_compute_instance_group.my_instance_group: Still creating... [50s elapsed]
yandex_compute_instance_group.my_instance_group: Still creating... [1m0s elapsed]
yandex_compute_instance_group.my_instance_group: Still creating... [1m10s elapsed]
yandex_compute_instance_group.my_instance_group: Still creating... [1m20s elapsed]
yandex_compute_instance_group.my_instance_group: Still creating... [1m30s elapsed]
yandex_compute_instance_group.my_instance_group: Still creating... [1m40s elapsed]
yandex_compute_instance_group.my_instance_group: Still creating... [1m50s elapsed]
yandex_compute_instance_group.my_instance_group: Still creating... [2m0s elapsed]
yandex_compute_instance_group.my_instance_group: Still creating... [2m10s elapsed]
yandex_compute_instance_group.my_instance_group: Still creating... [2m20s elapsed]
yandex_compute_instance_group.my_instance_group: Still creating... [2m30s elapsed]
yandex_compute_instance_group.my_instance_group: Still creating... [2m40s elapsed]
yandex_compute_instance_group.my_instance_group: Still creating... [2m50s elapsed]
yandex_compute_instance_group.my_instance_group: Creation complete after 2m53s [id=cl16hdeqkmbs4s1hp6ts]
yandex_lb_network_load_balancer.my_network_lb: Creating...
yandex_lb_network_load_balancer.my_network_lb: Still creating... [10s elapsed]
yandex_lb_network_load_balancer.my_network_lb: Creation complete after 12s [id=enpdjd2u23lftgaqkb19]

Apply complete! Resources: 6 added, 0 changed, 0 destroyed.

Outputs:

yandex_lb_network_load_balancer = tolist([
  "158.160.141.120",
])
```
![](/pic/15-cloud-manage-2-resources.png)
![](/pic/15-cloud-manage-2-web-app.png)


4. (дополнительно)* Создать Application Load Balancer с использованием Instance group и проверкой состояния.

Полезные документы:

- [Compute instance group](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/compute_instance_group).
- [Network Load Balancer](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/lb_network_load_balancer).
- [Группа ВМ с сетевым балансировщиком](https://cloud.yandex.ru/docs/compute/operations/instance-groups/create-with-balancer).

---
## Задание 2*. AWS (задание со звёздочкой)

Это необязательное задание. Его выполнение не влияет на получение зачёта по домашней работе.

**Что нужно сделать**

Используя конфигурации, выполненные в домашнем задании из предыдущего занятия, добавить к Production like сети Autoscaling group из трёх EC2-инстансов с  автоматической установкой веб-сервера в private домен.

1. Создать бакет S3 и разместить в нём файл с картинкой:

 - Создать бакет в S3 с произвольным именем (например, _имя_студента_дата_).
 - Положить в бакет файл с картинкой.
 - Сделать доступным из интернета.
2. Сделать Launch configurations с использованием bootstrap-скрипта с созданием веб-страницы, на которой будет ссылка на картинку в S3. 
3. Загрузить три ЕС2-инстанса и настроить LB с помощью Autoscaling Group.

Resource Terraform:

- [S3 bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket)
- [Launch Template](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template).
- [Autoscaling group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group).
- [Launch configuration](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_configuration).

Пример bootstrap-скрипта:

```
#!/bin/bash
yum install httpd -y
service httpd start
chkconfig httpd on
cd /var/www/html
echo "<html><h1>My cool web-server</h1></html>" > index.html
```
