
resource "yandex_vpc_network" "my_network" {
  name = "my-network"
}

resource "yandex_vpc_subnet" "my_subnet" {
  name           = "my-subnet"
  zone           = var.default_zone
  network_id     = yandex_vpc_network.my_network.id
  v4_cidr_blocks = var.default_cidr
}

resource "yandex_lb_network_load_balancer" "my_network_lb" {
  name = "my-network-lb"

  attached_target_group {
    target_group_id = yandex_compute_instance_group.my_instance_group.load_balancer.0.target_group_id

    healthcheck {
      name                = "nginx"
      interval            = 10
      timeout             = 5
      unhealthy_threshold = 3
      tcp_options {
        port = 80
      }
    }
  }
  listener {
    name = "lb-listener-http"
    port = 80
    external_address_spec {
      ip_version = "ipv4"
    }
  }

  listener {
    name = "lb-listener-https"
    port = 443
    external_address_spec {
      ip_version = "ipv4"
    }
  }
}
