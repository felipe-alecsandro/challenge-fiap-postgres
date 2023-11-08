variable "env" {}
variable "app_name" {}
variable "db_instance_class" {}
variable "db_port" {
  default = 5432
}
variable "db_name" {}
variable "db_username" {}
variable "db_password" {}
variable "db_identifier" {}
variable "db_engine_version" {
  type    = string
  default = "13.10"
}
variable "db_allocated_storage" {
  default = 100
}
variable "db_max_allocated_storage" {
  default = 1000
}
variable "subnet_ids" {}
variable "vpc_security_group_ids" {}