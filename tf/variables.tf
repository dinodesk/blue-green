variable "aws_region" {
  type = string
}

variable "project_name" {
  type    = string
  default = "blue-green"
}

variable "environment" {
  type = string
}

variable "branch_name" {
  type = string
}

variable "container_port" {
  type    = number
  default = 8000
}

variable "desired_count" {
  type    = number
  default = 2
}

variable "cpu" {
  type    = number
  default = 256
}

variable "memory" {
  type    = number
  default = 512
}

variable "bootstrap_image" {
  type        = string
  description = "Immutable bootstrap image. BG-6/BG-7 replace this with the exact application digest."
}

variable "release_version" {
  type        = string
  default     = "0.0.0.0"
  description = "Deployment version supplied by automation. Before merge this may be Major.Minor.PR.CI-revision; after merge it is Major.Minor.Release.Revision. Terraform does not allocate or increment versions."

  validation {
    condition     = can(regex("^[0-9]+\\.[0-9]+\\.[0-9]+\\.[0-9]+$", var.release_version))
    error_message = "release_version must use Major.Minor.Release.Revision format, for example 0.1.0.1."
  }
}

variable "health_check_path" {
  type    = string
  default = "/health"
}

variable "tags" {
  type    = map(string)
  default = {}
}
