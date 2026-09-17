# Инициализируем наш новый локальный модуль vpc
module "vpc_dev" {
  source   = "./vpc"
  env_name = "develop"
  zone     = "ru-central1-a"
  cidr     = "10.0.1.0/24"
}

# 1. Вызов remote-модуля для проекта Marketing
module "marketing_vm" {
  source         = "git::https://github.com/udjin10/yandex_compute_instance.git?ref=main"
  env_name       = "develop" 
  network_id     = module.vpc_dev.subnet.network_id   # Берем ID сети из outputs модуля vpc
  subnet_zones   = ["ru-central1-a"]
  subnet_ids     = [module.vpc_dev.subnet.id]           # Берем ID подсети из outputs модуля vpc
  instance_name  = "marketing-web"
  instance_count = 1
  image_family   = "ubuntu-2004-lts"
  public_ip      = true

  labels = { 
    project = "marketing"
  }

  metadata = {
    ssh-keys           = "ubuntu:${var.public_key}"
    user-data          = data.template_file.cloudinit.rendered
    serial-port-enable = 1
  }
}

# 2. Вызов remote-модуля для проекта Analytics
module "analytics_vm" {
  source         = "git::https://github.com/udjin10/yandex_compute_instance.git?ref=main"
  env_name       = "develop" 
  network_id     = module.vpc_dev.subnet.network_id   # Берем ID сети из outputs модуля vpc
  subnet_zones   = ["ru-central1-a"]
  subnet_ids     = [module.vpc_dev.subnet.id]           # Берем ID подсети из outputs модуля vpc
  instance_name  = "analytics-web"
  instance_count = 1
  image_family   = "ubuntu-2004-lts"
  public_ip      = true

  labels = { 
    project = "analytics"
  }

  metadata = {
    ssh-keys           = "ubuntu:${var.public_key}"
    user-data          = data.template_file.cloudinit.rendered
    serial-port-enable = 1
  }
}

# Передача переменной с SSH-ключом в cloud-init.yml без хардкода
data "template_file" "cloudinit" {
  template = file("./cloud-init.yml")
  
  vars = {
    ssh_key = var.public_key
  }
}
