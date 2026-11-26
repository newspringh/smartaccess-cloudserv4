# Shared Kubernetes security group.
resource "openstack_networking_secgroup_v2" "k8s" {
  name        = "smartaccess-k8s"
  description = "SmartAccess Kubernetes node communication"
}

# Allow internal communication between Kubernetes nodes.
resource "openstack_networking_secgroup_rule_v2" "internal_ipv4" {
  direction         = "ingress"
  ethertype         = "IPv4"
  remote_group_id   = openstack_networking_secgroup_v2.k8s.id
  security_group_id = openstack_networking_secgroup_v2.k8s.id
}

# Allow SSH from approved university and VPN networks.
resource "openstack_networking_secgroup_rule_v2" "ssh" {
  for_each = toset(var.admin_cidrs)

  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = each.value
  security_group_id = openstack_networking_secgroup_v2.k8s.id
}

# Allow Kubernetes API access from approved networks.
resource "openstack_networking_secgroup_rule_v2" "kubernetes_api" {
  for_each = toset(var.admin_cidrs)

  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 6443
  port_range_max    = 6443
  remote_ip_prefix  = each.value
  security_group_id = openstack_networking_secgroup_v2.k8s.id
}

output "k8s_security_group_id" {
  description = "Security group for RKE2 nodes."
  value       = openstack_networking_secgroup_v2.k8s.id
}
