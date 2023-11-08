# AWS MySQL Service

Terraform module which deploys MySQL service on AWS.

## Usage

```hcl
module "example" {
  source = "..."

  infrastructure = {
    vpc_id              = "..."
    default_domain_name = "..."
  }

  deployment = {
    version  = "8.0"          # https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/MySQL.Concepts.VersionMgmt.html
    type     = "replication"  # i.e. standalone, replication
    username = "root"
    password = "..."
    database = "mydb"
  }
}
```

## Examples

- [Replication](./examples/replication)
- [Standalone](./examples/standalone)

## Contributing

Please read our [contributing guide](./docs/CONTRIBUTING.md) if you're interested in contributing to Walrus template.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.24.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3.5.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.24.0 |
| <a name="provider_random"></a> [random](#provider\_random) | >= 3.5.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_db_instance.primary](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance) | resource |
| [aws_db_instance.secondary](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance) | resource |
| [aws_db_parameter_group.target](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_parameter_group) | resource |
| [aws_db_subnet_group.target](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_subnet_group) | resource |
| [aws_security_group.target](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.target](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_service_discovery_instance.primay](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/service_discovery_instance) | resource |
| [aws_service_discovery_instance.secondary](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/service_discovery_instance) | resource |
| [aws_service_discovery_service.primary](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/service_discovery_service) | resource |
| [aws_service_discovery_service.secondary](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/service_discovery_service) | resource |
| [random_password.password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_string.name_suffix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [aws_kms_key.selected](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/kms_key) | data source |
| [aws_service_discovery_dns_namespace.selected](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/service_discovery_dns_namespace) | data source |
| [aws_subnets.selected](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) | data source |
| [aws_vpc.selected](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_context"></a> [context](#input\_context) | Receive contextual information. When Walrus deploys, Walrus will inject specific contextual information into this field.<br><br>Examples:<pre>context:<br>  project:<br>    name: string<br>    id: string<br>  environment:<br>    name: string<br>    id: string<br>  resource:<br>    name: string<br>    id: string</pre> | `map(any)` | `{}` | no |
| <a name="input_infrastructure"></a> [infrastructure](#input\_infrastructure) | Specify the infrastructure information for deploying.<br><br>Examples:<pre>infrastructure:<br>  vpc_id: string                  # the ID of the VPC where the MySQL service applies<br>  kms_key_id: sting,optional      # the ID of the KMS key which to encrypt the MySQL data<br>  domain_suffix: string           # a private DNS namespace of the CloudMap where to register the applied MySQL service</pre> | <pre>object({<br>    vpc_id        = string<br>    kms_key_id    = optional(string)<br>    domain_suffix = string<br>  })</pre> | n/a | yes |
| <a name="input_deployment"></a> [deployment](#input\_deployment) | Specify the deployment action, including architecture and account.<br><br>Examples:<pre>deployment:<br>  version: string, optional      # https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/MySQL.Concepts.VersionMgmt.html<br>  type: string, optional         # i.e. standalone, replication<br>  username: string, optional     # limitation: https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/MySQL.KnownIssuesAndLimitations.html#MySQL.Concepts.KnownIssuesAndLimitations.KillProcedures<br>  password: string, optional     # limitation: https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/CHAP_Limits.html#RDS_Limits.Constraints<br>  database: string, optional<br>  parameters:                    # https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/AuroraMySQL.Reference.html<br>    - name: string               # unique<br>      value: string<br>  resources:<br>    class: string, optional      # https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Concepts.DBInstanceClass.html#Concepts.DBInstanceClass.Summary<br>  storage:<br>    class: string, optional      # https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/CHAP_Storage.html<br>    size: number, optional       # in megabyte</pre> | <pre>object({<br>    version  = optional(string, "8.0")<br>    type     = optional(string, "standalone")<br>    username = optional(string, "root")<br>    password = optional(string)<br>    database = optional(string, "mydb")<br>    parameters = optional(list(object({<br>      name  = string<br>      value = string<br>    })))<br>    resources = optional(object({<br>      class = optional(string, "db.t3.medium")<br>    }), { class = "db.t3.medium" })<br>    storage = optional(object({<br>      class = optional(string, "gp2")<br>      size  = optional(number, 20 * 1024)<br>    }), { class = "gp2", size = 20 * 1024 })<br>  })</pre> | <pre>{<br>  "database": "mydb",<br>  "resources": {<br>    "class": "db.t3.medium"<br>  },<br>  "storage": {<br>    "class": "gp2",<br>    "size": 20480<br>  },<br>  "type": "standalone",<br>  "username": "root",<br>  "version": "8.0"<br>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_context"></a> [context](#output\_context) | The input context, a map, which is used for orchestration. |
| <a name="output_selector"></a> [selector](#output\_selector) | The selector, a map, which is used for dependencies or collaborations. |
| <a name="output_endpoint_internal"></a> [endpoint\_internal](#output\_endpoint\_internal) | The internal endpoints, a string list, which are used for internal access. |
| <a name="output_endpoint_internal_readonly"></a> [endpoint\_internal\_readonly](#output\_endpoint\_internal\_readonly) | The internal readonly endpoints, a string list, which are used for internal readonly access. |
| <a name="output_database"></a> [database](#output\_database) | The name of database to access. |
| <a name="output_username"></a> [username](#output\_username) | The username of the account to access the database. |
| <a name="output_password"></a> [password](#output\_password) | The password of the account to access the database. |
<!-- END_TF_DOCS -->

## License

Copyright (c) 2023 [Seal, Inc.](https://seal.io)

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at [LICENSE](./LICENSE) file for details.

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
