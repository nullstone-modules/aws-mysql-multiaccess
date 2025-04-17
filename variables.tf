variable "app_metadata" {
  description = <<EOF
Nullstone automatically injects metadata from the app module into this module through this variable.
This variable is a reserved variable for capabilities.
EOF

  type    = map(string)
  default = {}
}

locals {
  security_group_id = var.app_metadata["security_group_id"]
}

variable "database_name" {
  type        = string
  description = <<EOF
Name of database to create in Mysql cluster. If left blank, uses app name.
The following identifiers are supported for interpolation:
  {{ NULLSTONE_STACK }}
  {{ NULLSTONE_BLOCK }}
  {{ NULLSTONE_ENV }}
EOF
  default     = ""
}

// We are using ns_env_variables to interpolate database_name
data "ns_env_variables" "db_name" {
  input_env_variables = tomap({
    NULLSTONE_STACK = local.stack_name
    NULLSTONE_APP   = local.block_name
    NULLSTONE_ENV   = local.env_name
    DATABASE_NAME   = coalesce(var.database_name, local.block_name)
  })
  input_secrets = tomap({})
}

locals {
  database_name = data.ns_env_variables.db_name.env_variables["DATABASE_NAME"]
}

variable "additional_database_names" {
  type        = set(string)
  description = <<EOF
Additional databases to create in the mysql cluster. If any already exist, they will be reused.
For each database, a new user will be created and granted owner permissions to the database schema.

The following identifiers are supported for interpolation:
  {{ NULLSTONE_STACK }}
  {{ NULLSTONE_BLOCK }}
  {{ NULLSTONE_ENV }}
EOF
  default     = []
}

locals {
  clean_additional_database_names = toset([for db in var.additional_database_names : db if trimspace(coalesce(db, "")) != ""])
}

data "ns_env_variables" "additional_db_names" {
  for_each = local.clean_additional_database_names

  input_env_variables = tomap({
    NULLSTONE_STACK = local.stack_name
    NULLSTONE_APP   = local.block_name
    NULLSTONE_ENV   = local.env_name
    DATABASE_NAME   = each.value
  })
  input_secrets = tomap({})
}

locals {
  additional_database_names = toset([for ev in data.ns_env_variables.additional_db_names : ev.env_variables["DATABASE_NAME"]])
}

