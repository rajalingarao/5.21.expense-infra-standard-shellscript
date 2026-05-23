variable "project_name" {
  default = "expense"
}
variable "env" {
  default = "dev"
}
variable "common_tags" {
  default = {
    Project = "expense"
    Component = "frontend"
    Environment = "dev"
    Terraform = "true"
  }
}