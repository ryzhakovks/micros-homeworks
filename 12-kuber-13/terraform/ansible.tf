resource "local_file" "hosts_cfg" {
  content = templatefile("${abspath(path.module)}/hosts.tftpl",
    {
      masters = [yandex_compute_instance.master]
      workers = yandex_compute_instance.worker
    }
  )
  filename = "${abspath(path.module)}/hosts.cfg"
}
