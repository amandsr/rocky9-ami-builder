packer {
  required_plugins {
    amazon = {
      source  = "github.com/hashicorp/amazon"
      version = ">= 1.0.0"
    }
  }
}

variable "aws_region" {
  default = "us-east-1"
}

variable "ami_name" {
  default = "rocky9-golden-{{timestamp}}"
}

source "amazon-ebs" "rocky9" {
  region                  = var.aws_region
  instance_type           = "t3.medium"
  ssh_username            = "ec2-user"
  ami_name                = var.ami_name
  ami_description         = "Rocky Linux 9 golden AMI built from ISO"
  force_deregister        = true
  force_delete_snapshot   = true
  communicator            = "ssh"

  # Boot and install via local ISO and Kickstart
  boot_command = [
    "<tab> inst.text inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ks.cfg<enter>"
  ]

  # ISO file located locally on the GitHub runner VM
  iso_url      = "file:///home/vagrant/Rocky-9-latest-x86_64-dvd.iso"
  #iso_checksum = "sha256:$(sha256sum /home/vagrant/Rocky-9-latest-x86_64-dvd.iso | cut -d' ' -f1)"
  http_directory = "http"
}

build {
  name    = "rocky9-aws-golden"
  sources = ["source.amazon-ebs.rocky9"]

  provisioner "shell" {
    script = "scripts/cleanup_image.sh"
  }
}

