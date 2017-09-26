# image data
data "openstack_images_image_v2" "packstack_image" {
  name = "${var.image_name}"
  most_recent = true
}

/*# external network data
data "openstack_networking_network_v2" "packstack_external_net" {
  name = "${var.external_net_name}"
}*/