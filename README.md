# TD DevOps : Infrastructure Docker & Validation Ansible

Ce projet automatise le déploiement d'un serveur Web Nginx via **Terraform** (Provider Docker) et valide son bon fonctionnement ainsi que son hygiène de configuration via **Ansible**.

## Prérequis

* **Docker Desktop** (avec intégration WSL activée)
* **Terraform** (v1.x)
* **Ansible** (installé dans WSL/Linux)

## Utilisation

### 1. Déploiement de l'infrastructure (Terraform)
Terraform se charge de créer le Réseau, le Volume persistant et le Conteneur Docker.

```bash
# Initialiser les plugins
terraform init

# Visualiser le plan et appliquer
terraform apply -auto-approve

