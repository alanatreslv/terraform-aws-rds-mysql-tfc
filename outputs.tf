output "context" {
  description = "The input context, a map, which is used for orchestration."
  value       = var.context
}

output "selector" {
  description = "The selector, a map, which is used for dependencies or collaborations."
  value       = local.tags
}

output "endpoint_internal" {
  description = "The internal endpoints, a string list, which are used for internal access."
  value = [
    format("%s.%s", aws_service_discovery_service.primary.name, var.infrastructure.domain_suffix)
  ]
}

output "endpoint_internal_readonly" {
  description = "The internal readonly endpoints, a string list, which are used for internal readonly access."
  value = var.deployment.type == "replication" ? [
    format("%s.%s", aws_service_discovery_service.secondary[0].name, var.infrastructure.domain_suffix)
  ] : null
}

output "database" {
  description = "The name of database to access."
  value       = var.deployment.database
}

output "username" {
  description = "The username of the account to access the database."
  value       = var.deployment.username
}

output "password" {
  description = "The password of the account to access the database."
  value       = local.password
  sensitive   = true
}
