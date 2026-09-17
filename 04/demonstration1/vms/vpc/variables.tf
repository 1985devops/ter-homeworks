variable "env_name" {
  type        = string
  description = "Environment name (e.g. develop, stage)"
}

variable "zone" {
  type        = string
  description = "Yandex Cloud availability zone"
}

variable "cidr" {
  type        = string
  description = "VPC subnet CIDR block"
}
