
resource "yandex_compute_instance_group" "my_instance_group" {
  name               = "my-instance-group"
  service_account_id = var.service_account_id
  folder_id          = var.folder_id

  instance_template {
    platform_id = "standard-v1"
    metadata    = local.metadata

    boot_disk {
      initialize_params {
        image_id = "fd827b91d99psvq5fjit"
      }
    }

    scheduling_policy {
      preemptible = true
    }

    resources {
      cores         = var.vm_base.cores
      memory        = var.vm_base.memory
      core_fraction = var.vm_base.core_fraction
    }

    network_interface {
      nat        = true
      network_id = yandex_vpc_network.my_network.id
      subnet_ids = ["${yandex_vpc_subnet.my_subnet.id}"]
    }
  }

  scale_policy {
    fixed_scale {
      size = 3 # Количество ВМ в группе
    }
  }

  deploy_policy {
    max_unavailable = 2
    max_expansion   = 1
  }

  allocation_policy {
    zones = [var.default_zone]
  }

  health_check {
    tcp_options {
      port = 80
    }
    interval            = 10 # Интервал проверки состояния ВМ в секундах
    timeout             = 5  # Время ожидания ответа от ВМ в секундах
    unhealthy_threshold = 3  # Количество неудачных попыток до пометки ВМ как нездоровой
  }
  load_balancer {
    target_group_name = "my-network-lb"
  }
}
