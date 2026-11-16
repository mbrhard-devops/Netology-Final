output "k8s_cluster_id" {
  description = "ID Kubernetes кластера"
  value       = yandex_kubernetes_cluster.diplom_k8s.id
}

output "registry_id" {
  description = "ID Container Registry"
  value       = yandex_container_registry.diplom_registry.id
}

output "registry_name" {
  description = "Имя Container Registry"
  value       = yandex_container_registry.diplom_registry.name
}
