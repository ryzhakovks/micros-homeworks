output "external_ip_addresses" {
  value = {
    "${yandex_compute_instance.platform.name}" ="${yandex_compute_instance.platform.network_interface.0.nat_ip_address}"
    "${yandex_compute_instance.platform-db.name}" = "${yandex_compute_instance.platform-db.network_interface.0.nat_ip_address}"
  }
  description = "External ip addresses"
}