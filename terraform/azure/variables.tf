variable "location" {
  default = "northeurope"
}

variable "project" {
  default = "poc10"
}

variable "environment" {
  default = "dev"
}

variable "aks_node_count" {
  default = 1
}

variable "aks_node_size" {
  default = "Standard_B2s_v2"
}


variable "allowed_ip_ranges" {
  description = "IPs allowed to access AKS API"
  type        = list(string)
}