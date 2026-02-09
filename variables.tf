variable "container_name" {
  description = "Nom du conteneur Docker"
  type        = string
  default     = "mon-serveur-nginx"
}

variable "external_port" {
  description = "Port externe sur la machine hôte"
  type        = number
  default     = 8080
}
