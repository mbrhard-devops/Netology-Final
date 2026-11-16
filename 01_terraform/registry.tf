# Создаем приватный реестр для Docker-образов
resource "yandex_container_registry" "diplom_registry" {
  name      = "${var.project_name}-registry-v1"
  folder_id = var.folder_id
}
