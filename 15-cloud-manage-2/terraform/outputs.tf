
output "yandex_lb_network_load_balancer" {
  value = yandex_lb_network_load_balancer.my_network_lb.listener.*.external_address_spec[0].*.address
}
