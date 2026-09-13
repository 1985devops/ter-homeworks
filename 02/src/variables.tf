###cloud vars


variable "cloud_id" {
  type        = string
  default     = "b1gof6hinvr4d9bvjvqs"
  description = "https://yandex.ru"
}

variable "folder_id" {
  type        = string
  default     = "b1gr4foep912dm5tcph9"
  description = "https://yandex.ru"
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}
variable "default_cidr" {
  type        = list(string)
  default     = ["10.0.1.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "vpc_name" {
  type        = string
  default     = "develop"
  description = "VPC network & subnet name"
}


###ssh vars

variable "vms_ssh_public_key_path" {
  type        = string
  default     = "~/.ssh/id_ed25519.pub"
  description = "Путь к публичному SSH-ключу"
}
