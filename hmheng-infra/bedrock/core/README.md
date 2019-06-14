## Applying changes to brcore01

```
terraform plan -state state/prod/terraform.tfstate -out theplan
terraform apply -state state/prod/terraform.tfstate theplan
```

## Applying changes to brcoredev

```
terraform plan -state state/dev/terraform.tfstate -var-file state/dev/vars.tfvars -out theplan
terraform apply -state state/dev/terraform.tfstate theplan
```
