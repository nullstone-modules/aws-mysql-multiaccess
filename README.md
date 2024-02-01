# aws-mysql-multiaccess

Nullstone capability to grant access for a mysql database to an app.
If `additional_database_names` are specified, a user and owner permissions will be created for each database.

### Secrets

- `MYSQL_PASSWORD`
- `MYSQL_URL`

### Env Vars

- `MYSQL_USER`
- `MYSQL_DB`

### Security Group Rules

- `tcp:3306` <=> `mysql` connection
