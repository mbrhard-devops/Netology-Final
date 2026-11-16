# Создаем виртуальную облачную сеть (VPC)
resource "yandex_vpc_network" "diplom_net" {
  name = "${var.project_name}-network"
}

# Создаем подсети в разных зонах доступности
resource "yandex_vpc_subnet" "subnet_a" {
  name           = "${var.project_name}-subnet-a"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.diplom_net.id
  v4_cidr_blocks = ["10.1.0.0/24"]
}

resource "yandex_vpc_subnet" "subnet_d" {
  name           = "${var.project_name}-subnet-d"
  zone           = "ru-central1-d"
  network_id     = yandex_vpc_network.diplom_net.id
  v4_cidr_blocks = ["10.1.2.0/24"]
}

#resource "yandex_vpc_subnet" "subnet_e" {
#  name           = "${var.project_name}-subnet-e"
#  zone           = "ru-central1-e"
#  network_id     = yandex_vpc_network.diplom_net.id
#  v4_cidr_blocks = ["10.1.3.0/24"]
#}