# Даем SA право управлять хранилищем
resource "yandex_resourcemanager_folder_iam_member" "terraform_sa_storage_admin" {
  folder_id = var.folder_id
  role      = "storage.admin"
  member    = "serviceAccount:ajecu62ss6pg8ita17cu"
}