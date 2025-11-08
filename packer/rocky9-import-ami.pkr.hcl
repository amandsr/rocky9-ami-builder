packer {
  required_plugins {
    amazon = {
      source  = "github.com/hashicorp/amazon"
      version = ">= 1.1.0"
    }
  }
}

variable "aws_region" {
  default = "us-east-1"
}

variable "image_file" {
  default = "output-rocky9/rocky9.qcow2"
}

source "amazon-import" "rocky9" {
  region          = var.aws_region
  ami_name        = "rocky9-golden-{{timestamp}}"
  description     = "Rocky Linux 9 golden image imported from ISO build"
  license_type    = "BYOL"
  tags = {
    OS    = "RockyLinux"
    Build = "ISO"
  }
  source_ami_file = var.image_file
  format          = "qcow2"
}

build {
  name    = "rocky9-aws-ami"
  sources = ["source.amazon-import.rocky9"]
}
