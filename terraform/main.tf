# create SSH keypair
resource "openstack_compute_keypair_v2" "packstack_ssh_key" {
  name       = "packstack-ssh-key"
  public_key = "${file("${var.ssh_key_file}.pub")}"
}

module "nat_network" {
  source          = "modules/nat"
  external_net_id = "${var.external_net_id}"
}

module "api" {
  source        = "modules/packstack_node"
  image_id      = "${data.openstack_images_image_v2.packstack_image.id}"
  key_pair_name = "${openstack_compute_keypair_v2.packstack_ssh_key.name}"
  tenant_id     = "${module.nat_network.tenant_id}"
  fixed_ip      = "10.0.0.50"
  hostname      = "api.cloud"
/*  vcpus         = "2"
  ram           = "2048" */
}

module "net" {
  source        = "modules/packstack_node"
  image_id      = "${data.openstack_images_image_v2.packstack_image.id}"
  key_pair_name = "${openstack_compute_keypair_v2.packstack_ssh_key.name}"
  tenant_id     = "${module.nat_network.tenant_id}"
  fixed_ip      = "10.0.0.60"
  hostname      = "net.cloud"
/*  vcpus         = "2"
  ram           = "2048" */
}

module "cmp" {
  source        = "modules/packstack_node"
  image_id      = "${data.openstack_images_image_v2.packstack_image.id}"
  key_pair_name = "${openstack_compute_keypair_v2.packstack_ssh_key.name}"
  tenant_id     = "${module.nat_network.tenant_id}"
  fixed_ip      = "10.0.0.70"
  hostname      = "cmp.cloud"
/*  vcpus         = "2"
  ram           = "2048" */
}

resource "openstack_compute_floatingip_associate_v2" "fip" {
  floating_ip = "${var.floating_ip}"
  instance_id = "${module.api.instance_id}"

  # Generate ansible configs
  provisioner "local-exec" {
    command = "python ./generate_ansible_config.py ${var.ssh_key_file} ${var.floating_ip}"
  }

  # Wait for SSH Connectivity
  provisioner "remote-exec" {
    connection {
      host        = "${var.floating_ip}"
      user        = "${var.ssh_user_name}"
      private_key = "${file(var.ssh_key_file)}"
    }
    inline = "# Connected!"
  }

  provisioner "remote-exec" {
    connection {
      host        = "10.0.0.60"
      user        = "${var.ssh_user_name}"
      private_key = "${file(var.ssh_key_file)}"
      bastion_host        = "${var.floating_ip}"
      bastion_user        = "${var.ssh_user_name}"
      bastion_private_key = "${file(var.ssh_key_file)}"
    }
    inline = "# Connected!"
  }

  provisioner "remote-exec" {
    connection {
      host        = "10.0.0.70"
      user        = "${var.ssh_user_name}"
      private_key = "${file(var.ssh_key_file)}"
      bastion_host        = "${var.floating_ip}"
      bastion_user        = "${var.ssh_user_name}"
      bastion_private_key = "${file(var.ssh_key_file)}"
    }
    inline = "# Connected!"
  }

  # Prepare servers
  provisioner "local-exec" {
    command = "cd ../ansible && ansible-playbook playbooks/prepare.yml"
  }

  # Setup packstack
  provisioner "local-exec" {
    command = "cd ../ansible && ansible-playbook playbooks/packstack.yml"
  }
}
