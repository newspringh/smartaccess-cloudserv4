variable "project_name" {
  description = "Name of the SmartAccess project."
  type        = string
  default     = "smartaccess"
}

variable "cloud_name" {
  description = "OpenStack cloud configuration name."
  type        = string
  default     = "CloudServ4"
}

variable "image_id" {
  description = "Ubuntu 24.04 image ID."
  type        = string
  default     = "3cd2789f-3813-4de2-a871-cc845fb28b3b"
}

variable "instance_flavor" {
  description = "OpenStack flavor for Kubernetes nodes."
  type        = string
  default     = "m1.medium"
}

variable "ssh_key_name" {
  description = "Existing OpenStack SSH keypair."
  type        = string
  default     = "smartaccess-mac"
}

variable "initial_worker_count" {
  description = "Number of initial Kubernetes worker nodes."
  type        = number
  default     = 3

  validation {
    condition     = var.initial_worker_count == 3
    error_message = "SmartAccess requires exactly three worker nodes."
  }
}

variable "admin_cidrs" {
  description = "Approved IPv4 CIDRs for university and VPN administration."
  type        = list(string)
  nullable    = false

  validation {
    condition = (
      length(var.admin_cidrs) > 0 &&
      alltrue([
        for cidr in var.admin_cidrs :
        can(cidrnetmask(cidr))
      ])
    )
    error_message = "Provide at least one valid IPv4 administrative CIDR."
  }
}

variable "private_subnet_cidr" {
  description = "IPv4 subnet for SmartAccess Kubernetes nodes."
  type        = string
  default     = "192.168.100.0/24"

  validation {
    condition     = can(cidrnetmask(var.private_subnet_cidr))
    error_message = "A valid IPv4 CIDR is required."
  }
}
