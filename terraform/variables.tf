variable "ssh_key_file" {
  default = "~/.ssh/id_rsa"
}

variable "ssh_user_name" {
  default = "root"
}

variable "external_net_name" {
  default = "external-network"
}

variable "image_name" {
  default = "CentOS 7 64-bit"
}

variable "external_net_id" {}

variable "floating_ip" {}