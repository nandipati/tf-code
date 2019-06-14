## Applying changes to brnpb

```
terraform plan -state state/prod/terraform.tfstate -out theplan
terraform apply -state state/prod/terraform.tfstate theplan
```
