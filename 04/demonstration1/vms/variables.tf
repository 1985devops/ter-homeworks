variable "public_key" {
  type        = string
  description = "SSH public key for VMs"
}

variable "cloud_id" {
  type        = string
  description = "Yandex Cloud ID"
}

variable "folder_id" {
  type        = string
  description = "Yandex Cloud Folder ID"
}

variable "zone" {
  type        = string
  description = "Yandex Cloud Zone"
  default     = "ru-central1-a"
}

variable "yc_token" {
  type        = string
  description = "Yandex Cloud OAuth or IAM token"
}
