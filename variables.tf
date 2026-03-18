variable "gitlab_token" {
  description = "Token de acceso privado de GitLab con permisos de API"
  type        = string
}

variable "gitlab_url" {
  description = "URL base de GitLab API"
  type        = string
  default     = "https://umane.emeal.nttdata.com/api/v4"
}

variable "jenkins_url" {
  description = "URL del webhook de Jenkins"
  type        = string
  default     = "https://20.8.203.204/gitlab-webhook/post"
}

variable "branch_regex" {
  description = "Expresión para filtrar ramas que disparan el webhook"
  type        = string
  default     = "^(integration|certification|loadtesting)$"
}

variable "target_type" {
  description = "Modo de configuración: 'group' para todos los repos del grupo, 'project' para repos concretos"
  type        = string
  validation {
    condition     = contains(["group", "project"], var.target_type)
    error_message = "target_type debe ser 'group' o 'project'."
  }
}

variable "group_path" {
  description = "Path del grupo GitLab (ej: mi-grupo). Solo necesario si target_type = 'group'"
  type        = string
  default     = ""
}

variable "project_paths" {
  description = "Lista de paths de proyectos con namespace (ej: mi-grupo/mi-repo). Solo necesario si target_type = 'project'"
  type        = list(string)
  default     = []
}
