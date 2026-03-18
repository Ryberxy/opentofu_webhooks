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

variable "repos" {
  description = "Lista de repositorios de microservicios a configurar"
  type        = list(string)
  default = [
    "microservicio1",
    "microservicio2",
    "microservicio3",
    "microservicio4",
    "microservicio5",
    "microservicio6",
    "microservicio7",
    "microservicio8",
    "microservicio9",
    "microservicio10",
    "microservicio11",
    "microservicio12",
    "microservicio13",
    "microservicio14",
    "microservicio15",
    "microservicio16",
    "microservicio17",
    "microservicio18",
    "microservicio19",
    "microservicio20"
  ]
}
