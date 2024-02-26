# Заменить на ID своего облака
# https://console.cloud.yandex.ru/cloud?section=overview
variable "yandex_cloud_id" {
  default = ""
}

# Заменить на Folder своего облака
# https://console.cloud.yandex.ru/cloud?section=overview
variable "yandex_folder_id" {
  default = ""
}

# Заменить на ID своего образа
# ID можно узнать с помощью команды yc compute image list
variable "image_id" {
  default = "fd8dgtuscndkp3jmdb82"
}

variable "yandex_token" {
  default = ""
}
