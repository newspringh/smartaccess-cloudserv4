# Security group for all SmartAccess Kubernetes nodes.
resource "openstack_networking_secgroup_v2" "k8s" {
  name        = "smartaccess-k8s"
  description = "Internal Kubernetes node communication"
}

# Allow communication between nodes within the same group.
resource "openstack_networking_secgroup_rule_v2" "internal_ipv4" {
  direction         = "ingress"
  ethertype         = "IPv4"
  remote_group_id   = openstack_networking_secgroup_v2.k8s.id
  security_group_id = openstack_networking_secgroup_v2.k8s.id
}

# Allow SSH access only from the configured administrative CIDR.
resource "openstack_networking_secgroup_rule_v2" "ssh" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = var.admin_cidr
  security_group_id = openstack_networking_secgroup_v2.k8s.id
}

# Restrict Kubernetes API access to the administrative CIDR.
resource "openstack_networking_secgroup_rule_v2" "kubernetes_api" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 6443
  port_range_max    = 6443
  remote_ip_prefix  = var.admin_cidr
  security_group_id = openstack_networking_secgroup_v2.k8s.id
}

output "k8s_security_group_id" {
  description = "Security group ID for Kubernetes nodes."
  value       = openstack_networking_secgroup_v2.k8s.id
}
