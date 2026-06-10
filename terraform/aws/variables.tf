variable "aws_region" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "public_access_cidrs" {
  type = list(string)
}

variable "cluster_admin_arn" {
  description = "IAM principal with EKS cluster admin access"
  type        = string
}