locals {
  metadata = {
    ssh-keys           = "${var.user_name}:${file("~/.ssh/id_rsa.pub")}"
    serial-port-enable = 1
    user-data          = "#!/bin/bash\n echo \"<html><head><title>My Web App</title></head><body><h1>Welcome to My Web App</h1><img src='https://${yandex_storage_bucket.my_bucket_qazwsx.bucket_domain_name}/${yandex_storage_object.content_bg.key}'></body></html>\" > /var/www/html/index.html"
  }
}

