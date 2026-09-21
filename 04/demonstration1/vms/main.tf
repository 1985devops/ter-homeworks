#создаем облачную сеть
resource "yandex_vpc_network" "develop" {
  name = "develop"
}

#создаем подсеть
resource "yandex_vpc_subnet" "develop_a" {
  name           = "develop-ru-central1-a"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = ["10.0.1.0/24"]
}

resource "yandex_vpc_subnet" "develop_b" {
  name           = "develop-ru-central1-b"
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = ["10.0.2.0/24"]
}

module "test-vm" {
  # Зафиксировали стабильную версию тегом вместо ветки main
  source         = "git::https://github.com"
  env_name       = "develop" 
  network_id     = yandex_vpc_network.develop.id
  subnet_zones   = ["ru-central1-a","ru-central1-b"]
  subnet_ids     = [yandex_vpc_subnet.develop_a.id,yandex_vpc_subnet.develop_b.id]
  instance_name  = "webs"
  instance_count = 2
  image_family   = "ubuntu-2004-lts"
  
  # Безопасность: убрали публичный IP и серийный порт
  public_ip      = false

  labels = { 
    owner   = "i.ivanov",
    project = "accounting"
  }

  metadata = {
    # Заменили устаревший data-источник на встроенную функцию
    user-data          = templatefile("./cloud-init.yml", {})
    serial-port-enable = 0
  }
}

module "example-vm" {
  # Зафиксировали версию
  source         = "git::https://github.com"
  env_name       = "stage"
  network_id     = yandex_vpc_network.develop.id
  subnet_zones   = ["ru-central1-a"]
  subnet_ids     = [yandex_vpc_subnet.develop_a.id]
  instance_name  = "web-stage"
  instance_count = 1
  image_family   = "ubuntu-2004-lts"
  
  # Безопасность: убрали публичный IP и серийный порт
  public_ip      = false

  metadata = {
    # Заменили устаревший data-источник на встроенную функцию
    user-data          = templatefile("./cloud-init.yml", {})
    serial-port-enable = 0
  }
}
