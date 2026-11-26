# Existing external network provided by the university.
# This resource is read-only and is not managed by Terraform.
data "openstack_networking_network_v2" "external" {
  name = "ext_net"
}

# Dedicated private network for the SmartAccess Kubernetes cluster.
resource "openstack_networking_network_v2" "smartaccess" {
  name           = "smartaccess-net"
  admin_state_up = true
}

# Private IPv4 subnet used by the Kubernetes nodes.
resource "openstack_networking_subnet_v2" "smartaccess" {
  name            = "smartaccess-subnet"
  network_id      = openstack_networking_network_v2.smartaccess.id
  cidr            = "192.168.100.0/24"
  ip_version      = 4
  gateway_ip      = "192.168.100.1"
  enable_dhcp     = true
  dns_nameservers = ["1.1.1.1", "9.9.9.9"]
}

# Router connecting the private network to the external network.
resource "openstack_networking_router_v2" "smartaccess" {
  name                = "smartaccess-router"
  admin_state_up      = true
  external_network_id = data.openstack_networking_network_v2.external.id
}

# Attach the private subnet to the SmartAccess router.
resource "openstack_networking_router_interface_v2" "smartaccess" {
  router_id = openstack_networking_router_v2.smartaccess.id
  subnet_id = openstack_networking_subnet_v2.smartaccess.id
}
