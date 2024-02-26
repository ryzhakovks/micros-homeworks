resource "yandex_compute_instance" "node01" {
  name                      = "node01"
  zone                      = "ru-central1-a"
  hostname                  = "node01.netology.cloud"
  allow_stopping_for_update = true
  platform_id               = "standard-v2"

  resources {
    cores         = 4
    core_fraction = 100
    memory        = 4
  }

  boot_disk {
    initialize_params {
      image_id = var.image_id
      name     = "root-node01"
      type     = "network-nvme"
      size     = "30"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.default.id
    nat       = true
  }

  metadata = {
    ssh-keys = "centos:${file("~/.ssh/id_rsa.pub")}"
  }
}
