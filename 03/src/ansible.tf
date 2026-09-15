resource "local_file" "hosts_cfg" {
  content = templatefile("${path.module}/hosts.tpl",
    {
      webservers = yandex_compute_instance.web
      databases  = values(yandex_compute_instance.db) # values() преобразует map от for_each в список
      storage    = [yandex_compute_instance.storage] # оборачиваем одиночную ВМ в список для цикла
    }
  )
  filename = "${path.module}/hosts.cfg"
}
