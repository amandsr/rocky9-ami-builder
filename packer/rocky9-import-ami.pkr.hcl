packer {
  required_version = ">= 1.8"
  required_plugins {
    amazon = {
      version = ">= 1.0.3"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

variable "aws_region" {
  type = string
}

variable "qcow2_path" {
  type = string
}

source "amazon-import" "rocky9" {
  region       = var.aws_region
  name         = "rocky9-byos-ami"
  description  = "Rocky Linux 9 BYOS AMI built from ISO"
  license_type = "BYOL"

  disk_container {
    format = "qcow2"
    user_bucket {
      s3_bucket = ""
      s3_key    = var.qcow2_path
    }
  }
}

build {
  sources = ["source.amazon-import.rocky9"]
}
