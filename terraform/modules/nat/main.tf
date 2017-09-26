# create private network
resource "openstack_networking_network_v2" "packstack_tenant" {
  name           = "packstack-tenant-net"
  admin_state_up = "true"
}

# create subnet for private network
resource "openstack_networking_subnet_v2" "packstack_subnet" {
  name            = "packstack-subnet"
  network_id      = "${openstack_networking_network_v2.packstack_tenant.id}"
  cidr            = "10.0.0.0/24"
  ip_version      = 4
  dns_nameservers = ["8.8.8.8", "8.8.4.4"]
}

# create router
resource "openstack_networking_router_v2" "packstack_router" {
  name             = "packstack-nat-router"
  admin_state_up   = "true"
  external_gateway = "${var.external_net_id}"
}

# create interface in private subnet for router
resource "openstack_networking_router_interface_v2" "packstack_router_interface" {
  router_id = "${openstack_networking_router_v2.packstack_router.id}"
  subnet_id = "${openstack_networking_subnet_v2.packstack_subnet.id}"
}