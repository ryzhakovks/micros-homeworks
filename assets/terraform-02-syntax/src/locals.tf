locals {
  prefix = "netology-develop-"
  vm_web = "platform-web"
  vm_db  = "platform-db"
  vm_web_instance_name = "${local.prefix}-${local.vm_web}"
  vm_db_instance_name = "${local.prefix}-${local.vm_db}"
}