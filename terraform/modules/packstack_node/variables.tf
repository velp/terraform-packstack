variable "image_id" {}

variable "key_pair_name" {}

variable "tenant_id" {}

variable "fixed_ip" {}

variable "hostname" {}

variable "disk_size" {
  default = "15"
}

variable "vcpus" {
  default = "4"
}

variable "ram" {
  default = "8192"
}