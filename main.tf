terraform {
  required_providers {
    gitlab = {
      source  = "gitlabhq/gitlab"
      version = "~> 3.15"
    }
  }
}

provider "gitlab" {
  token    = var.gitlab_token
  base_url = var.gitlab_url
}

# Obtener datos de todos los proyectos
data "gitlab_project" "repos" {
  for_each = toset(var.repos)
  name     = each.key
}

# Crear webhooks a Jenkins
resource "gitlab_project_hook" "jenkins_hooks" {
  for_each = data.gitlab_project.repos

  project = each.value.id
  url     = var.jenkins_url

  push_events               = true
  merge_requests_events     = false
  enable_ssl_verification   = true
  push_events_branch_filter = var.branch_regex
}
