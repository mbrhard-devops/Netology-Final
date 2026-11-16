# Создаем управляемый Kubernetes кластер
resource "yandex_kubernetes_cluster" "diplom_k8s" {
  name        = "${var.project_name}-k8s-cluster"
  description = "Diploma Managed Kubernetes Cluster"
  network_id  = yandex_vpc_network.diplom_net.id

  # Привязываем созданный сервисный аккаунт
  service_account_id      = yandex_iam_service_account.k8s_sa.id
  node_service_account_id = yandex_iam_service_account.k8s_sa.id

  release_channel = "STABLE"
  
  # Master-нода управляется Яндексом (zonal - дешевле и проще)
  master {
    version = "1.35"
    zonal {
      zone      = var.zone
      subnet_id = yandex_vpc_subnet.subnet_d.id
    }
    public_ip = true # Для подключения kubectl
  }

  # Ждём применения всех IAM-ролей перед созданием кластера
  depends_on = [
    yandex_resourcemanager_folder_iam_member.k8s_agent,
    yandex_resourcemanager_folder_iam_member.vpc_public_admin,
    yandex_resourcemanager_folder_iam_member.images_puller
  ]
}

# Создаем группу worker-нод
resource "yandex_kubernetes_node_group" "diplom_workers" {
  cluster_id = yandex_kubernetes_cluster.diplom_k8s.id
  name       = "${var.project_name}-workers"

  instance_template {
    platform_id = "standard-v2"
    resources {
      cores         = 2
      memory        = 4
      core_fraction = 50
    }
    
    boot_disk {
      type = "network-hdd"
      size = 30
    }

    # Прерываемые ноды для экономии бюджета
    scheduling_policy {
      preemptible = true
    }

    network_interface {
      # Распределяем ноды по подсетям
      subnet_ids = [
        yandex_vpc_subnet.subnet_d.id,
        yandex_vpc_subnet.subnet_a.id,
      #  yandex_vpc_subnet.subnet_e.id
      ]
      nat = true # Внешние IP для доступа по NodePort
    }
  }

  # worker-ноды
  scale_policy {
    fixed_scale {
      size = 2
    }
  }

  allocation_policy {
    location { zone = "ru-central1-d" }
    location { zone = "ru-central1-a" }
   # location { zone = "ru-central1-e" }
  }
}