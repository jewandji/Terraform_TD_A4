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
```

**Sortie attendue : L'URL d'accès (ex: http://localhost:8080) et l'ID du conteneur s'affichent.**

### 2. Validation et Tests (Ansible)
Ansible vérifie que le service répond correctement (Code 200) et respecte les règles d'hygiène (Running, Port exposé, Politique de redémarrage).

```Bash
# Lancer le playbook de test
ansible-playbook -i inventory.ini playbook.yml
```

### 3. Nettoyage
Pour détruire l'ensemble des ressources créées :

```Bash
terraform destroy -auto-approve
```

## Architecture du Projet
* **main.tf :** Déclaration des ressources (Image, Network, Volume, Container).

* **variables.tf :** Configuration flexible (Nom du conteneur, Port externe).

* **outputs.tf :** Exposition des données dynamiques (URL, ID) pour l'utilisateur ou les scripts.

* **playbook.yml :** Script de test Ansible (Validation HTTP + Hygiène Docker).

* **inventory.ini :** Cible locale pour Ansible.

## Réponses aux Questions du TD

### 1. Pourquoi séparer provisionnement (Terraform) et validation (Ansible) ?
Responsabilités distinctes : Terraform est un outil d'Infrastructure as Code (IaC) déclaratif, idéal pour gérer le cycle de vie des ressources (création, modification, destruction). Ansible est ici utilisé pour son rôle de validation procédurale et d'audit.

Indépendance : Terraform construit les "murs" (le conteneur). Ansible vérifie "l'électricité" (le service applicatif). Si le test Ansible échoue, cela signifie que l'application a un problème, même si l'infrastructure est "UP".

### 2. En quoi les outputs Terraform facilitent l'automatisation ?
Les outputs permettent d'exporter des données dynamiques qui ne sont connues qu'après le déploiement (comme une IP attribuée ou un ID aléatoire). Ils servent de "glu" entre les outils : Terraform donne l'info (ex: le port 8080), et un script ou un pipeline CI/CD peut récupérer cette info pour lancer les tests au bon endroit sans avoir besoin de coder les valeurs en dur (hardcoding).

### 3. Quelle est la valeur d'Ansible dans un rôle "non configurant" ?
Audit et Conformité : Dans ce projet, Ansible n'installe rien. Il agit comme un auditeur qualité ("Quality Gate"). Il applique le principe "Trust but Verify" : Terraform dit que c'est déployé, Ansible prouve que ça marche réellement.

Hygiène : Il s'assure que les bonnes pratiques sont respectées (ex: vérifier que restart_policy est bien actif) sans risquer de créer une dérive de configuration (Configuration Drift).

### 4. Comment ce socle évoluerait vers un environnement CI/CD ?
Ce projet est prêt à être intégré dans un pipeline (GitHub Actions, GitLab CI) :

* **Stage Build :** Construction de l'image Docker personnalisée.

* **Stage Provision :** Exécution de terraform apply sur un environnement éphémère.

* **Stage Test :** Exécution du ansible-playbook. Si ce stage échoue, le pipeline s'arrête (pas de mise en prod).

* **Stage Cleanup :** terraform destroy si c'était un test, ou déploiement final si c'était pour la production.

## Troubleshooting
Si une erreur d'API Docker survient **(client version 1.41 is too old)**, vérifier la version du provider dans le main et mettre la dernière version de l'API que l'on utilise sur son projet.
