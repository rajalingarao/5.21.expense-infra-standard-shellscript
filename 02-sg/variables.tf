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
variable "db_sg_description" {
  default = "SG for DB MySQL Instances" 
}