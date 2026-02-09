terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.6.2"
    }
  }
}

provider "docker" {
}

# 1. Image
resource "docker_image" "nginx" {
  name         = "nginx:latest"
  keep_locally = false
}

# 2. Réseau
resource "docker_network" "private_network" {
  name = "td_network"
}

# 3. Volume
resource "docker_volume" "data_volume" {
  name = "td_volume_data"
}

# 4. Conteneur
resource "docker_container" "nginx" {
  image = docker_image.nginx.image_id
  name  = var.container_name

  ports {
    internal = 80
    external = var.external_port
  }

  restart = "always"

  networks_advanced {
    name = docker_network.private_network.name
  }

  volumes {
    volume_name    = docker_volume.data_volume.name
    container_path = "/usr/share/nginx/html"
  }
}
