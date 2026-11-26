# Internal Kubernetes communication between cluster nodes.
resource "openstack_networking_secgroup_v2" "k8s" {
  name        = "smartaccess-k8s"
  description = "Internal traffic between SmartAccess Kubernetes nodes"
}

resource "openstack_networking_secgroup_rule_v2" "internal_ipv4" {
  direction         = "ingress"
  ethertype         = "IPv4"
  remote_group_id   = openstack_networking_secgroup_v2.k8s.id
  security_group_id = openstack_networking_secgroup_v2.k8s.id
}

# Administrative access is restricted to cp01.
resource "openstack_networking_secgroup_v2" "management" {
  name        = "smartaccess-management"
  description = "Restricted SSH and Kubernetes API administration"
}

resource "openstack_networking_secgroup_rule_v2" "ssh" {
  for_each = toset(var.admin_cidrs)

  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = each.value
  security_group_id = openstack_networking_secgroup_v2.management.id
}

resource "openstack_networking_secgroup_rule_v2" "kubernetes_api" {
  for_each = toset(var.admin_cidrs)

  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 6443
  port_range_max    = 6443
  remote_ip_prefix  = each.value
  security_group_id = openstack_networking_secgroup_v2.management.id
}

output "k8s_security_group_id" {
  description = "Internal Kubernetes security group."
  value       = openstack_networking_secgroup_v2.k8s.id
}

output "management_security_group_id" {
  description = "Restricted administrative security group."
  value       = openstack_networking_secgroup_v2.management.id
}
