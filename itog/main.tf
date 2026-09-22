terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

data "yandex_compute_image" "ubuntu-latest" {
  family = "ubuntu-2204-lts"
}

# 1. Настройка провайдера
provider "yandex" {
  token     = ""
  cloud_id  = ""
  folder_id = ""
  zone      = "ru-central1-a"
}

# 2. Создание сети VPC
resource "yandex_vpc_network" "project-net" {
  name = "project-network"
}

# 3. Создание подсети
resource "yandex_vpc_subnet" "project-subnet" {
  name           = "project-subnet-a"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.project-net.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}

# 4. Настройка Группы безопасности (порты 22, 80, 443)
resource "yandex_vpc_security_group" "project-sg" {
  name        = "project-security-group"
  network_id  = yandex_vpc_network.project-net.id

  # SSH доступ
  ingress {
    protocol       = "TCP"
    description    = "SSH"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 22
  }

  # HTTP доступ
  ingress {
    protocol       = "TCP"
    description    = "HTTP"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 80
  }

  # HTTPS доступ
  ingress {
    protocol       = "TCP"
    description    = "HTTPS"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 443
  }

  # Разрешаем весь исходящий трафик
  egress {
    protocol       = "ANY"
    description    = "Outbound"
    v4_cidr_blocks = ["0.0.0.0/0"]
    from_port      = 0
    to_port        = 65535
  }
}

# 5. Создание Виртуальной Машины (VM)
resource "yandex_compute_instance" "web-vm" {
  name        = "web-server"
  platform_id = "standard-v3"

  resources {
    cores         = 2
    memory        = 2
    core_fraction = 20
  }

  scheduling_policy {
    preemptible = true
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu-latest.id
      size     = 20
    }
  }
  network_interface {
    subnet_id          = yandex_vpc_subnet.project-subnet.id
    nat                = true
  }

  metadata = {
    user-data = <<EOF
#cloud-config
package_update: true
packages:
  - docker.io
  - docker-compose-v2
runcmd:
  - usermod -aG docker ubuntu
  - systemctl enable docker
  - systemctl start docker
EOF
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}

# 6. Описание создания Container Registry
resource "yandex_container_registry" "project-cr" {
  name      = "project-registry"
}

# 7. Описание создания БД MySQL (Managed Service for MySQL)
resource "yandex_mdb_mysql_cluster" "project-mysql" {
  name        = "project-mysql-db"
  environment = "PRESTABLE" # Для тестов и учебных проектов
  network_id  = yandex_vpc_network.project-net.id
  version     = "8.0"       # <-- ДОБАВЬ ЭТУ СТРОКУ СЮДА

  resources {
    resource_preset_id = "s3-c2-m8" # Минимальный тестовый класс машины
    disk_type_id       = "network-hdd"
    disk_size          = 10
  }

  host {
    zone      = "ru-central1-a"
    subnet_id = yandex_vpc_subnet.project-subnet.id
  }
}

# Создаем базу данных внутри кластера
resource "yandex_mdb_mysql_database" "db" {
  cluster_id = yandex_mdb_mysql_cluster.project-mysql.id
  name       = "app_database"
}

# Создаем пользователя БД
resource "yandex_mdb_mysql_user" "user" {
  cluster_id = yandex_mdb_mysql_cluster.project-mysql.id
  name       = "db_user"
  password   = "SuperSecretPassword123!"
  
  permission {
    database_name = yandex_mdb_mysql_database.db.name
    roles         = ["ALL"]
  }
}
