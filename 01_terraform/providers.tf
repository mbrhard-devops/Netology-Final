terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "~> 0.130.0"
    }
  }
  required_version = ">= 1.5.0"

  backend "s3" {
    endpoint                    = "https://storage.yandexcloud.net"
    bucket                      = "diplom-tf-state-bucket-b1gep0"
    region                      = "ru-central1"
    key                         = "terraform.tfstate"
    
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
    skip_requesting_account_id  = true
  }
}

provider "yandex" {
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
  zone      = var.zone
  
  # SA-ключ (постоянная авторизация)
  service_account_key_file = var.sa_key_file
}

variable "sa_key_file" {
  description = "Путь к ключу сервисного аккаунта"
  type        = string
  default     = "/home/user-test/Netology/Final/sa-key.json"
}