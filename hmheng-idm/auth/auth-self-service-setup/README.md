# Auth Self Service Setup
This Terraform script contains the required DB setup for Self Service. The service allows customers and HMH staff to setup SSO trust connectons. 

* [Repo](https://github.com/hmhco/auth-self-service-setup)
* [Slack Channel](https://hmhco.slack.com/messages/C452J1341)
* [Docs](https://identity-docs.prod.hmheng-idm.brnp.internal/Auth/Self-Service/README/)

## Configuration to Change DB to UTF-8
The script contains the steps to configure the DB to `UTF-8`. I used this doc to help me understand the process [MySQL UTF-8](https://mathiasbynens.be/notes/mysql-utf8mb4). The main two bits to remember are:
 * Settings for a single DB are added to the DB
 * If there is a cluster of DB's, the settings are set on the cluster and it applys them to each DB.

 Some helpful links and docs:
  * [Terraform Cluster Doc](https://www.terraform.io/docs/providers/aws/r/rds_cluster.html)
  * [Terraform Cluster Parameter Group ](https://www.terraform.io/docs/providers/aws/r/rds_cluster_parameter_group.html)
  * [Terraform DB Parameter Group](https://www.terraform.io/docs/providers/aws/r/db_parameter_group.html)

  Links to the allowed parameters for a db instance and the cluster:
  * [MySQL DB Parameters](https://hmhco.box.com/s/uk8krrcm6dozxp0ru80e799ufxvysx9s)
  * [Aurora DB Parameters Within a Cluster](https://hmhco.box.com/s/52g4iewd61z0qikgrvk7v2j4qme9a8ag)
  * [Aurora Cluster Parameters](https://hmhco.box.com/s/9kc8j7mv1n4p9fwrkllnvzk6mxdumo5z)