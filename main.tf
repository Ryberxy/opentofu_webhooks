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

# ── MODO GRUPO ──────────────────────────────────────────────────────────────
data "gitlab_group" "target" {
  count     = var.target_type == "group" ? 1 : 0
  full_path = var.group_path
}

data "gitlab_projects" "group_projects" {
  count    = var.target_type == "group" ? 1 : 0
  group_id = data.gitlab_group.target[0].id
}

# ── MODO PROYECTO INDIVIDUAL ─────────────────────────────────────────────────
data "gitlab_project" "single_projects" {
  for_each            = var.target_type == "project" ? toset(var.project_paths) : toset([])
  path_with_namespace = each.key
}

# ── UNIFICACIÓN DE IDs ────────────────────────────────────────────────────────
locals {
  group_projects_map = var.target_type == "group" ? {
    for p in data.gitlab_projects.group_projects[0].projects :
    p.path_with_namespace => tostring(p.id)
  } : {}

  single_projects_map = var.target_type == "project" ? {
    for k, v in data.gitlab_project.single_projects :
    k => tostring(v.id)
  } : {}

  all_projects = merge(local.group_projects_map, local.single_projects_map)
}

# ── WEBHOOKS ──────────────────────────────────────────────────────────────────
resource "gitlab_project_hook" "jenkins_hooks" {
  for_each = local.all_projects

  project                   = each.value
  url                       = var.jenkins_webhook_url
  push_events               = true
  merge_requests_events     = true
  enable_ssl_verification   = true
  push_events_branch_filter = var.branch_regex
}

# ── OUTPUTS ───────────────────────────────────────────────────────────────────
output "webhooks_configurados" {
  description = "Proyectos con webhook configurado"
  value       = keys(local.all_projects)
}