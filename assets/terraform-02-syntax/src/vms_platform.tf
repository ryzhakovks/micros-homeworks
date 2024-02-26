variable "vm_web_resources" {
  type = map
  default = {
    cores = 2,
    memory = 1,
    core_fraction = 5
  }
}

variable "vm_db_resources" {
  type = map
  default = {
    cores = 2,
    memory = 2,
    core_fraction = 20
  }
}