# Создаем сервисный аккаунт для Kubernetes
resource "yandex_iam_service_account" "k8s_sa" {
  name        = "${var.project_name}-k8s-sa"
  description = "Service account for Managed Kubernetes cluster"
}

# Роль editor на уровень каталога
#resource "yandex_resourcemanager_folder_iam_member" "k8s_sa_editor" {
#  folder_id = var.folder_id
#  role      = "editor"
#  member    = "serviceAccount:${yandex_iam_service_account.k8s_sa.id}"
#}

# Роль для управления ресурсами кластера и работы нод
resource "yandex_resourcemanager_folder_iam_member" "k8s_agent" {
  folder_id = var.folder_id
  role      = "k8s.clusters.agent"
  member    = "serviceAccount:${yandex_iam_service_account.k8s_sa.id}"
}

# Роль для создания балансировщиков и публичных IP
resource "yandex_resourcemanager_folder_iam_member" "vpc_public_admin" {
  folder_id = var.folder_id
  role      = "vpc.publicAdmin"
  member    = "serviceAccount:${yandex_iam_service_account.k8s_sa.id}"
}

# Роль для скачивания образов из приватного Container Registry
resource "yandex_resourcemanager_folder_iam_member" "images_puller" {
  folder_id = var.folder_id
  role      = "container-registry.images.puller"
  member    = "serviceAccount:${yandex_iam_service_account.k8s_sa.id}"
}

# Находим существующий сервисный аккаунт по ID
data "yandex_iam_service_account" "existing_sa" {
  service_account_id = "ajecu62ss6pg8ita17cu"
}

# Роль viewer на каталог для сервисного аккаунта
resource "yandex_resourcemanager_folder_iam_binding" "sa_viewer" {
  folder_id = var.folder_id
  role      = "viewer"
  members = [
    "serviceAccount:${data.yandex_iam_service_account.existing_sa.id}"
  ]
}

# Роль для создания балансировщиков
resource "yandex_resourcemanager_folder_iam_member" "k8s_lb_admin" {
  folder_id = var.folder_id
  role      = "load-balancer.admin"
  member    = "serviceAccount:${yandex_iam_service_account.k8s_sa.id}"
}

# Роль для управления ВМ
resource "yandex_resourcemanager_folder_iam_member" "k8s_compute_admin" {
  folder_id = var.folder_id
  role      = "compute.admin"
  member    = "serviceAccount:${yandex_iam_service_account.k8s_sa.id}"
}