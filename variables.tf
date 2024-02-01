variable "app_metadata" {
  description = <<EOF
Nullstone automatically injects metadata from the app module into this module through this variable.
This variable is a reserved variable for capabilities.
EOF

  type    = map(string)
  default = {}
}

variable "database_name" {
  type        = string
  description = <<EOF
Name of database to create in the mysql cluster. If left blank, the name of the app will be used.
If the database already exists, it will be reused.
A new user will be created and granted owner permissions to the database schema.
EOF
  default     = ""
}

variable "additional_database_names" {
  type        = list(string)
  description = <<EOF
Additional databases to create in the mysql cluster. If any already exist, they will be reused.
For each database, a new user will be created and granted owner permissions to the database schema.
EOF
  default     = []
}

locals {
  security_group_id = var.app_metadata["security_group_id"]
  username          = local.resource_name
  database_name     = coalesce(var.database_name, local.block_name)
}
