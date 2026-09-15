resource "yandex_compute_disk" "storage_disk" {
  count = 3

  name = "disk-${count.index + 1}"
  type = "network-hdd"
  size = 1 # Размер в Гб
}

resource "yandex_compute_instance" "storage" {
  name        = "storage"
  platform_id = "standard-v1"

  resources {
    cores         = 2
    memory        = 2
    core_fraction = 5
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
  }

  dynamic "secondary_disk" {
    for_each = yandex_compute_disk.storage_disk
    content {
      disk_id = secondary_disk.value.id
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${local.ssh_key}"
    serial-port-enable = "1"
  }

  scheduling_policy {
    preemptible = true # Прерываемая ВМ для экономии
  }
}
