variable "project_id" { }

variable "region" {
  default = "europe-central2"
}

variable "zone" {
  default = "europe-central2-c"
}

variable "db_password" {
  type      = string
  sensitive = true
}
