variable "cloud_id" {
  description = "ID облака Yandex Cloud"
  type        = string
  default     = "b1gd2s0bh49gmd73m704"
}

variable "folder_id" {
  description = "ID каталога Yandex Cloud"
  type        = string
  default     = "b1gep0d4pp10h24g8gd0"
}

variable "zone" {
  description = "Основная зона доступности для master-ноды"
  type        = string
  default     = "ru-central1-d"
}

variable "project_name" {
  description = "Префикс для всех создаваемых ресурсов"
  type        = string
  default     = "diplom"
}
