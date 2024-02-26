
resource "yandex_vpc_network" "base_network" {
  name = var.vpc_name
}

resource "yandex_vpc_subnet" "public" {
  name           = "public"
  zone           = var.default_zone
  network_id     = yandex_vpc_network.base_network.id
  v4_cidr_blocks = var.default_cidr
}

resource "yandex_vpc_route_table" "private_route" {
  name = "private_route"
  network_id = yandex_vpc_network.base_network.id
  static_route {
    destination_prefix = "0.0.0.0/0"
    next_hop_address = yandex_compute_instance.public_instance.network_interface.0.ip_address
  }
}

resource "yandex_vpc_subnet" "private" {
  name           = "private"
  zone           = var.default_zone
  network_id     = yandex_vpc_network.base_network.id
  v4_cidr_blocks = var.private_cidr
  route_table_id = yandex_vpc_route_table.private_route.id
}
