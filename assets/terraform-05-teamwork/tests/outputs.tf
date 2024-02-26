output "ip_address" {
  value = var.ip_address
  description = "ip_address"
}

output "ip_address_IPv4" {
  value = var.ip_address_IPv4
  description = "ip_address_IPv4"
}

output "ip_addresses" {
  value = var.ip_addresses.*
  description = "ip_address"
}

output "lower_case_string" {
  value = var.lower_case_string
  description = "lower_case_string"
}

output "in_the_end_there_can_be_only_one" {
  value = var.in_the_end_there_can_be_only_one
  description = "in_the_end_there_can_be_only_one"
}