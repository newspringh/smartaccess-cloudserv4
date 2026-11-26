# Initial RKE2 cluster nodes.
# All instances are created in the dedicated SmartAccess network.
locals {
  kubernetes_nodes = {
    "smartaccess-cp01" = {
      role = "control-plane"
    }
    "smartaccess-worker01" = {
      role = "worker"
    }
    "smartaccess-worker02" = {
      role = "worker"
    }
    "smartaccess-worker03" = {
      role = "worker"
    }
  }
}

# Create the initial Kubernetes virtual machines.
resource "openstack_compute_instance_v2" "kubernetes_nodes" {
  for_each = local.kubernetes_nodes

  name        = each.key
  image_id    = var.image_id
  flavor_name = var.instance_flavor
  key_pair    = var.ssh_key_name
  user_data   = file("${path.module}/cloud-init/base.yaml")

  security_groups = each.value.role == "control-plane" ? [
    openstack_networking_secgroup_v2.k8s.name,
    openstack_networking_secgroup_v2.management.name
    ] : [
    openstack_networking_secgroup_v2.k8s.name
  ]

  network {
    uuid = openstack_networking_network_v2.smartaccess.id
  }

  metadata = {
    project = var.project_name
    role    = each.value.role
    managed = "terraform"
  }

  depends_on = [
    openstack_networking_router_interface_v2.smartaccess
  ]
}

# Return the private IP addresses of the cluster nodes.
output "kubernetes_node_private_ips" {
  description = "Private IPv4 addresses of Kubernetes nodes."

  value = {
    for name, instance in openstack_compute_instance_v2.kubernetes_nodes :
    name => instance.access_ip_v4
  }
}
