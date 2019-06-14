### Staging Processor Database

Here within contains the terraform configuration for the staging processor database. Origionally this cluster was used by Clever API but it as since been reaquired for use with the Staging Processor and the Staging API for use in the new rostering pipeline.

The origional names of the resources have not changed.


### Terraform Note

Unlike other folders in here and other terraform service structures, this does not have a state folder for dev, int, cert, prod. Just one large terraform file. This is mostly a relic as this services was one of the first to use terraform within the platform teams.

### Remote State Config
terraform remote config \
    -backend=s3 \
    -backend-config="bucket=bedrock-terraform-state" \
    -backend-config="key=idm-clever/terraform.tfstate" \
    -backend-config="region=us-east-1"
