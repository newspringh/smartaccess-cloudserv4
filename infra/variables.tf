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

variable "admin_cidr" {
  description = "Trusted administrative network CIDR for SSH and Kubernetes API."
  type        = string
  nullable    = false

  validation {
    condition     = can(cidrhost(var.admin_cidr, 0))
    error_message = "admin_cidr must be a valid IPv4 or IPv6 CIDR."
  }
}
