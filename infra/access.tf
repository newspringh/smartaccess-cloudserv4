# Allocate one Floating IP on the existing external network.
resource "openstack_networking_floatingip_v2" "management" {
  pool = data.openstack_networking_network_v2.external.name
}

# Find the Neutron port belonging to the first control-plane node.
data "openstack_networking_port_v2" "cp01" {
  device_id  = openstack_compute_instance_v2.kubernetes_nodes["smartaccess-cp01"].id
  network_id = openstack_networking_network_v2.smartaccess.id
}

# Associate the management Floating IP with cp01.
resource "openstack_networking_floatingip_associate_v2" "management" {
  floating_ip = openstack_networking_floatingip_v2.management.address
  port_id     = data.openstack_networking_port_v2.cp01.id
}

output "management_floating_ip" {
  description = "Management Floating IP assigned to cp01."
  value       = openstack_networking_floatingip_v2.management.address
}

output "ssh_connection_details" {
  description = "SSH connection parameters for the cluster."

  value = {
    user              = "ubuntu"
    identity_file     = "~/.ssh/id_ed25519"
    bastion           = "smartaccess-cp01"
    bastion_public_ip = openstack_networking_floatingip_v2.management.address

    worker_private_ips = {
      for name, instance in openstack_compute_instance_v2.kubernetes_nodes :
      name => instance.network[0].fixed_ip_v4
      if name != "smartaccess-cp01"
    }
  }
}
