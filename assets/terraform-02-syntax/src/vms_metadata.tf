variable "vms_metadata" {
  type        = map
  default = {
    serial-port-enable = 1,
    ssh-keys = "ubuntu:ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH11IEL+6KtNYHtjYvOOaUu81srhgVo7N/S0le90rBjF v_sid@LAPTOP-2QLN04RI"
  }
  description = "VM metadata"
}