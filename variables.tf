variable "prefix" {
  description = "Prefix applied to firewall rule names"
  type        = "string"
}

variable "droplet_ids" {
  description = "List of droplet ids to which the rule sets will be applied"
  type        = "list"
  default     = []
}

variable "tags" {
  description = "List of tag ids, any droplet matching these tags will have the rule set applied"
  type        = "list"
  default     = []
}

variable "remote_api_port" {
  default     = 2376
  description = "TCP port on which the Docker Remote API may be exposed"
}

variable "api_access_tags" {
  default     = []
  type        = "list"
  description = "List of droplet tags from which Docker Remote API access is allowed."
}

variable "api_access_droplet_ids" {
  default     = []
  type        = "list"
  description = "List of droplet ids from which Docker Remote API access is allowed."
}

variable "api_access_from_adresses" {
  default     = ["0.0.0.0/0", "::/0"]
  type        = "list"
  description = "An array of strings containing the IPv4 addresses, IPv6 addresses, IPv4 CIDRs, and/or IPv6 CIDRs from which Docker Remote API access is allowed."
}

variable "api_access_load_balancer_uids" {
  default     = []
  type        = "list"
  description = "An array containing the IDs of the Load Balancers from which Docker Remote API access is allowed."
}
