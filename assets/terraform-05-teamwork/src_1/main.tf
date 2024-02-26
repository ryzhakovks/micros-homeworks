terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }

  # backend "local" {

  # }
  backend "s3" {
    endpoint = "storage.yandexcloud.net"
    bucket   = "tfstate-va-develop"

    key    = "terraform.tfstate"
    region = "ru-central1"

    dynamodb_endpoint = "https://docapi.serverless.yandexcloud.net/ru-central1/b1gamuvki52hfn7mdg4j/etnf4pfcia246c8m2241"
    dynamodb_table    = "tflock"

    skip_region_validation      = true
    skip_credentials_validation = true
  }

  required_version = ">=0.13"
}

provider "yandex" {
  token     = var.token
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
  zone      = var.default_zone
}

module "vpc_dev" {
  source   = "./vpc_2"
  env_name = "develop"
  subnets = [
    { zone = "ru-central1-a", cidr = "10.0.1.0/24" },
  ]
}

module "test-vm" {
  source         = "git::https://github.com/udjin10/yandex_compute_instance.git?ref=main"
  env_name       = "develop"
  network_id     = module.vpc_dev.vpc_id
  subnet_zones   = module.vpc_dev.vpc_zones
  subnet_ids     = module.vpc_dev.subnet_ids
  instance_name  = "web"
  instance_count = 1
  image_family   = "ubuntu-2004-lts"
  public_ip      = true

  metadata = {
    user-data          = data.template_file.cloudinit.rendered
    serial-port-enable = 1
  }

}

#Пример передачи cloud-config в ВМ для демонстрации №3
data "template_file" "cloudinit" {
  template = file("./cloud-init.yml")

  vars = {
    username       = var.username
    ssh_public_key = file(var.ssh_public_key)
    packages       = jsonencode(var.packages)
  }
}

