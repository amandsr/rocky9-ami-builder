packer {
  required_plugins {
    qemu = {
      source  = "github.com/hashicorp/qemu"
      version = ">= 1.1.0"
    }
  }
}

variable "iso_path" {
  default = "/home/vagrant/Rocky-9-latest-x86_64-dvd.iso"
}

source "qemu" "rocky9" {
  accelerator       = "kvm"
  iso_url           = "file://${var.iso_path}"
  iso_checksum      = "8ff2a47e2f3bfe442617fceb7ef289b7b1d2d0502089dbbd505d5368b2b3a90f"
  output_directory  = "output-rocky9"
  disk_size         = "10G"
  memory            = 2048
  cpus              = 2
  format            = "qcow2"
  headless          = true
  ssh_username      = "ec2-user"
  ssh_password      = "packer"
  ssh_timeout       = "30m"
  http_directory    = "http"

  boot_command = [
    "<tab> inst.text inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ks.cfg<enter>"
  ]
}

build {
  name    = "rocky9-qemu-image"
  sources = ["source.qemu.rocky9"]

  provisioner "shell" {
    script = "scripts/cleanup_image.sh"
  }

  post-processor "compress" {
    output = "rocky9.qcow2.gz"
  }
}
