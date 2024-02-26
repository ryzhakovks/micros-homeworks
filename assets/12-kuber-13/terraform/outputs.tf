output "master_ip" {
  value = "${yandex_compute_instance.master.name} - ${yandex_compute_instance.master.network_interface.0.ip_address}(${yandex_compute_instance.master.network_interface.0.nat_ip_address})"
}

output "worker_ips" {
  value = [for instance in yandex_compute_instance.worker : "${instance.name} - ${instance.network_interface.0.ip_address}(${instance.network_interface.0.nat_ip_address})"]
}
