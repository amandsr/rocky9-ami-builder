packer {
  required_version = ">= 1.8"
  required_plugins {
    qemu = {
      version = ">= 1.1.4"
      source  = "github.com/hashicorp/qemu"
    }
  }
}

variable "iso_path" {
  type    = string
  default = "/home/vagrant/Rocky-9-latest-x86_64-dvd.iso"
}

variable "iso_checksum" {
  type    = string
  default = "8ff2a47e2f3bfe442617fceb7ef289b7b1d2d0502089dbbd505d5368b2b3a90f" # use "sha256:<value>" if validating checksum
}

variable "kickstart_file" {
  type    = string
  default = "rocky9-ks.cfg"
}

source "qemu" "rocky9" {
  accelerator       = "kvm"
  format            = "qcow2"
  disk_size         = "20480M"
  cpus              = 2
  memory            = "4096"
  net_device        = "virtio-net"
  headless          = true

  # ✅ HCL2 syntax for variable interpolation
  iso_url           = "file://${var.iso_path}"
  iso_checksum      = var.iso_checksum

  # ✅ Correct argument name
  boot_command = [
    "<wait5><enter>",
    "linux inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/${var.kickstart_file}<enter>"
  ]

  http_directory     = "."
  ssh_username       = "rocky"
  ssh_password       = "packer"
  ssh_timeout        = "20m"
  shutdown_command   = "sudo shutdown -P now"
  output_directory   = "output-rocky9"
}

build {
  name    = "rocky9-qcow2"
  sources = ["source.qemu.rocky9"]
}
