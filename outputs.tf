output "container_id" {
  value       = docker_container.nginx.id
  description = "ID du conteneur"
}

output "website_url" {
  value       = "http://localhost:${var.external_port}"
  description = "URL d'accès"
}
