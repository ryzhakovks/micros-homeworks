variable "service_account_id" {
  type = string
}

variable "token" {
  type = string
}

variable "access_key_id" {
  type = string
}

variable "secret_key" {
  type = string
}

variable "cloud_id" {
  type = string
}

variable "folder_id" {
  type = string
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}
