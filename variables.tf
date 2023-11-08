#
# Contextual Fields
#

variable "context" {
  description = <<-EOF
Receive contextual information. When Walrus deploys, Walrus will inject specific contextual information into this field.

Examples:
```
context:
  project:
    name: string
    id: string
  environment:
    name: string
    id: string
  resource:
    name: string
    id: string
```
EOF
  type        = map(any)
  default     = {}
}

#
# Infrastructure Fields
#

variable "infrastructure" {
  description = <<-EOF
Specify the infrastructure information for deploying.

Examples:
```
infrastructure:
  vpc_id: string                  # the ID of the VPC where the MySQL service applies
  kms_key_id: sting,optional      # the ID of the KMS key which to encrypt the MySQL data
  domain_suffix: string           # a private DNS namespace of the CloudMap where to register the applied MySQL service
```
EOF
  type = object({
    vpc_id        = string
    kms_key_id    = optional(string)
    domain_suffix = string
  })
}

#
# Deployment Fields
#

variable "deployment" {
  description = <<-EOF
Specify the deployment action, including architecture and account.

Examples:
```
deployment:
  version: string, optional      # https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/MySQL.Concepts.VersionMgmt.html
  type: string, optional         # i.e. standalone, replication
  username: string, optional     # limitation: https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/MySQL.KnownIssuesAndLimitations.html#MySQL.Concepts.KnownIssuesAndLimitations.KillProcedures
  password: string, optional     # limitation: https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/CHAP_Limits.html#RDS_Limits.Constraints
  database: string, optional
  parameters:                    # https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/AuroraMySQL.Reference.html
    - name: string               # unique
      value: string
  resources:
    class: string, optional      # https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Concepts.DBInstanceClass.html#Concepts.DBInstanceClass.Summary
  storage:
    class: string, optional      # https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/CHAP_Storage.html
    size: number, optional       # in megabyte
```
EOF
  type = object({
    version  = optional(string, "8.0")
    type     = optional(string, "standalone")
    username = optional(string, "root")
    password = optional(string)
    database = optional(string, "mydb")
    parameters = optional(list(object({
      name  = string
      value = string
    })))
    resources = optional(object({
      class = optional(string, "db.t3.medium")
    }), { class = "db.t3.medium" })
    storage = optional(object({
      class = optional(string, "gp2")
      size  = optional(number, 20 * 1024)
    }), { class = "gp2", size = 20 * 1024 })
  })
  default = {
    version  = "8.0"
    type     = "standalone"
    username = "root"
    database = "mydb"
    resources = {
      class = "db.t3.medium"
    }
    storage = {
      class = "gp2"
      size  = 20 * 1024
    }
  }
  validation {
    condition     = var.deployment.version == null || contains(["8.0", "5.7"], var.deployment.version)
    error_message = "Invalid version"
  }
  validation {
    condition     = var.deployment.type == null || contains(["standalone", "replication"], var.deployment.type)
    error_message = "Invalid type"
  }
  validation {
    condition     = var.deployment.username == null || can(regex("^[A-Za-z_]{0,15}[a-z0-9]$", var.deployment.username))
    error_message = format("Invalid username: %s", var.deployment.username)
  }
  validation {
    condition     = var.deployment.password == null || can(regex("^[A-Za-z0-9\\!#\\$%\\^&\\*\\(\\)_\\+\\-=]{8,32}", var.deployment.password))
    error_message = "Invalid password"
  }
  validation {
    condition     = var.deployment.database == null || can(regex("^[a-z][-a-z0-9_]{0,61}[a-z0-9]$", var.deployment.database))
    error_message = format("Invalid database: %s", var.deployment.database)
  }
  validation {
    condition     = var.deployment.storage == null || try(var.deployment.storage.size >= 20480, true)
    error_message = "Storage size must be larger than 20Gi"
  }
}
