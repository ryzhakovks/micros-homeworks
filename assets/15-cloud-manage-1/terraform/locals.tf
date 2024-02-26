locals {
  ssh_keys_and_serial_port = {
    ssh-keys           = "${var.user_name}:${file("~/.ssh/id_rsa.pub")}"
    serial-port-enable = 1
  }
}
