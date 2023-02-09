output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = module.vpc.private_subnets[*]
}

