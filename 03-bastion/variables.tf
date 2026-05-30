variable "common_tags" {
    type = map
    default = {
        Terraform   = "true"
        Environment = "dev"
        Project     = "expense"
    }
}
variable "project_name" {
    type = string
    default = "expense"
  }
variable "environment" {
     default = "dev"    
  }

variable "zone_id" {
  default = "Z012785114HGZTDQ8KSQH"
}