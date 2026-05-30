variable "project_name" {
  default = "expense"
}

variable "env" {
  default = "dev"
}

variable "common_tags" {
  default = {
    Project = "expense"
    Component = "mysql"
    Environment = "dev"
    Terraform = "true"
  }
}

variable "zone_id" {
  default = "Z012785114HGZTDQ8KSQH"
}