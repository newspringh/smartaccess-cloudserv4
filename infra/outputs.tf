# Private network identifier for compute instances.
output "private_network_id" {
  description = "ID of the SmartAccess private network."
  value       = openstack_networking_network_v2.smartaccess.id
}

# Private subnet identifier.
output "private_subnet_id" {
  description = "ID of the SmartAccess subnet."
  value       = openstack_networking_subnet_v2.smartaccess.id
}

# Router identifier.
output "router_id" {
  description = "ID of the SmartAccess router."
  value       = openstack_networking_router_v2.smartaccess.id
}

# External network identifier.
output "external_network_id" {
  description = "ID of the existing university external network."
  value       = data.openstack_networking_network_v2.external.id
}
