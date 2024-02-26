output "vpc_id" {
  value = yandex_vpc_network.develop.id
}

output "subnet_ids" {
  value = {
    for k, sbn in yandex_vpc_subnet.develop : k => sbn.id
  }
}

output "vpc_zones" {
  value = {
    for k, sbn in yandex_vpc_subnet.develop : k => sbn.zone
  }
}
