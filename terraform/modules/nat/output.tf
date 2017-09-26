output "tenant_id" {
  value = "${openstack_networking_network_v2.packstack_tenant.id}"
}