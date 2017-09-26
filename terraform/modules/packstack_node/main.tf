# create flavor
resource "openstack_compute_flavor_v2" "packstack_flavor" {
  name  = "packstack-flavor-for-${var.hostname}"
  ram   = "${var.ram}"
  vcpus = "${var.vcpus}"
  disk  = "0"
  is_public = "True"
}

# create volume
resource "openstack_blockstorage_volume_v2" "packstack_disk" {
  name        = "disk-for-api.cloud"
  size        = "${var.disk_size}"
  image_id    = "${var.image_id}"
}

# create instance
resource "openstack_compute_instance_v2" "packstack_instance" {
  name        = "${var.hostname}"
  flavor_id   = "${openstack_compute_flavor_v2.packstack_flavor.id}"
  key_pair    = "${var.key_pair_name}"

  network {
    uuid        = "${var.tenant_id}"
    fixed_ip_v4 = "${var.fixed_ip}"
  }

  metadata = {
    "x_sel_server_default_addr"  = "{\"ipv4\":\"\"}"
  }
 
  block_device {
    uuid   = "${openstack_blockstorage_volume_v2.packstack_disk.id}"
    source_type      = "volume"
    boot_index       = 0
    destination_type = "volume"
  }
}