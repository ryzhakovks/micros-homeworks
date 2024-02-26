
resource "yandex_vpc_network" "kubernetes" {
  name = var.vpc_name
}
resource "yandex_vpc_subnet" "kubernetes" {
  name           = var.vpc_name
  zone           = var.default_zone
  network_id     = yandex_vpc_network.kubernetes.id
  v4_cidr_blocks = var.default_cidr
}

resource "yandex_compute_instance" "master" {
  name        = "master"
  platform_id = "standard-v1"
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.id
      size     = var.vm_base.disk_size
    }
  }
  scheduling_policy {
    preemptible = true
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.kubernetes.id
    nat       = true
  }
  resources {
    cores         = var.vm_base.cores
    memory        = var.vm_base.memory
    core_fraction = var.vm_base.core_fraction
  }
  metadata = local.ssh_keys_and_serial_port
}

resource "yandex_compute_instance" "worker" {
  count       = 2
  name        = "worker-${count.index}"
  platform_id = "standard-v1"
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.id
      size     = var.vm_base.disk_size
    }
  }
  scheduling_policy {
    preemptible = true
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.kubernetes.id
    nat       = true
  }
  resources {
    cores         = var.vm_base.cores
    memory        = var.vm_base.memory
    core_fraction = var.vm_base.core_fraction
  }
  metadata = local.ssh_keys_and_serial_port
}
