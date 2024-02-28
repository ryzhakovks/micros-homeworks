# Домашнее задание к занятию «Безопасность в облачных провайдерах»  

Используя конфигурации, выполненные в рамках предыдущих домашних заданий, нужно добавить возможность шифрования бакета.

---
## Задание 1. Yandex Cloud   

1. С помощью ключа в KMS необходимо зашифровать содержимое бакета:

 - создать ключ в KMS;
 - с помощью ключа зашифровать содержимое бакета, созданного ранее.

Листинг команд:
```sh
D:\projects\devops-netology\assets\15-cloud-manage-3\terraform>terraform apply
yandex_kms_symmetric_key.my_symmetric_key: Creating...
yandex_kms_symmetric_key.my_symmetric_key: Creation complete after 2s [id=abjng61k8qhm706ucgta]
yandex_storage_bucket.my_bucket_qazwsx: Creating...
yandex_storage_bucket.my_bucket_qazwsx: Creation complete after 3s [id=my-bucket-qazwsx]
yandex_storage_object.content_bg: Creating...
yandex_storage_object.content_bg: Creation complete after 0s [id=test-img.jpg]
local_file.index_html: Creating...
local_file.index_html: Creation complete after 1s [id=e7b8ccdebc80d5cec518260c0a446256f56fec66]
yandex_storage_object.index_html: Creating...
yandex_storage_object.index_html: Creation complete after 0s [id=index.html]

Apply complete! Resources: 5 added, 0 changed, 0 destroyed.

Outputs:

yandex_storage_object_content_bg_url = "https://my-bucket-qazwsx.storage.yandexcloud.net/test-img.jpg"
yandex_storage_object_index_html_url = "https://my-bucket-qazwsx.storage.yandexcloud.net/index.html"
```

Файлы terraform:
- [object-storage.tf](/assets//15-cloud-manage-3/terraform/object-storage.tf)
- [web-app.tftpl](/assets//15-cloud-manage-3/terraform/web-app.tftpl)
- [outputs.tf](/assets//15-cloud-manage-3/terraform/outputs.tf)



2. (Выполняется не в Terraform)* Создать статический сайт в Object Storage c собственным публичным адресом и сделать доступным по HTTPS:

 - создать сертификат;
 - создать статическую страницу в Object Storage и применить сертификат HTTPS;
 - в качестве результата предоставить скриншот на страницу с сертификатом в заголовке (замочек).

Полезные документы:
- [Настройка HTTPS статичного сайта](https://cloud.yandex.ru/docs/storage/operations/hosting/certificate).
- [Object Storage bucket](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/storage_bucket).
- [KMS key](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/kms_symmetric_key).


![](/pic/15-cloud-manage-3-kms.png)

![](/pic/15-cloud-manage-3-object.png)

--- 

<details>
<summary>Задание 2*. AWS (задание со звёздочкой)</summary>


Это необязательное задание. Его выполнение не влияет на получение зачёта по домашней работе.

**Что нужно сделать**

1. С помощью роли IAM записать файлы ЕС2 в S3-бакет:
 - создать роль в IAM для возможности записи в S3 бакет;
 - применить роль к ЕС2-инстансу;
 - с помощью bootstrap-скрипта записать в бакет файл веб-страницы.
2. Организация шифрования содержимого S3-бакета:

 - используя конфигурации, выполненные в домашнем задании из предыдущего занятия, добавить к созданному ранее бакету S3 возможность шифрования Server-Side, используя общий ключ;
 - включить шифрование SSE-S3 бакету S3 для шифрования всех вновь добавляемых объектов в этот бакет.

3. *Создание сертификата SSL и применение его к ALB:

 - создать сертификат с подтверждением по email;
 - сделать запись в Route53 на собственный поддомен, указав адрес LB;
 - применить к HTTPS-запросам на LB созданный ранее сертификат.

Resource Terraform:

- [IAM Role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role).
- [AWS KMS](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key).
- [S3 encrypt with KMS key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_object#encrypting-with-kms-key).

Пример bootstrap-скрипта:

```
#!/bin/bash
yum install httpd -y
service httpd start
chkconfig httpd on
cd /var/www/html
echo "<html><h1>My cool web-server</h1></html>" > index.html
aws s3 mb s3://mysuperbacketname2021
aws s3 cp index.html s3://mysuperbacketname2021
```
</details>

