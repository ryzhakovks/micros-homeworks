terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">=0.13"
}

resource "yandex_vpc_network" "develop" {
  name = var.env_name
}

resource "yandex_vpc_subnet" "develop" {
  count          = length(var.subnets) > 0 ? length(var.subnets) : 0
  name           = "${var.env_name}-${var.subnets[count.index].zone}"
  zone           = var.subnets[count.index].zone
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = ["${var.subnets[count.index].cidr}"]
}
