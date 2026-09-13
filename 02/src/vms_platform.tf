variable "vm_web_family" {
  type        = string
  default     = "ubuntu-2004-lts"
  description = "Семейство ОС для поиска образа"
}

variable "vm_web_name" {
  type        = string
  default     = "netology-develop-platform-web"
  description = "Имя виртуальной машины"
}

variable "vm_web_platform_id" {
  type        = string
  default     = "standard-v3"
  description = "Платформа виртуальной машины"
}

# variable "vm_web_cores" {
#  type        = number
#  default     = 2
#  description = "Количество ядер процессора"
#}

# variable "vm_web_memory" {
#  type        = number
#  default     = 1
#  description = "Объем оперативной памяти в ГБ"
#}

# variable "vm_web_core_fraction" {
#  type        = number
#  default     = 20
#  description = "Гарантированная доля CPU в %"
#}

variable "vm_db_family" {
  type        = string
  default     = "ubuntu-2004-lts"
}
variable "vm_db_name" {
  type        = string
  default     = "netology-develop-platform-db"
}
variable "vm_db_platform_id" {
  type        = string
  default     = "standard-v3"
}
# variable "vm_db_cores" {
#  type        = number
#  default     = 2
#}
# variable "vm_db_memory" {
#  type        = number
#  default     = 2 # По заданию нужно 2 ГБ
#}
# variable "vm_db_core_fraction" {
#  type        = number
#  default     = 20
#}

variable "vms_resources" {
  type = map(object({
    cores         = number
    memory        = number
    core_fraction = number
  }))
  default = {
    web = {
      cores         = 2
      memory        = 1
      core_fraction = 20
    }
    db = {
      cores         = 2
      memory        = 2
      core_fraction = 20
    }
  }
}

variable "vms_metadata" {
  type = map(string)
  default = {
    serial-port-enable = "1"
    ssh-keys           = "ubuntu:~/.ssh/id_ed25519.pub"
  }
}
