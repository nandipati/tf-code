# Applying
## brnpa

```sh
terraform plan -var-file=state/brnpa/vars.tfvars -state=state/brnpa/terraform.tfstate -out plan
terraform apply -state=state/brnpa/terraform.tfstate plan
```

## brnpb
```sh
terraform plan -var-file=state/brnpb/vars.tfvars -state=state/brnpb/terraform.tfstate -out plan
terraform apply -state=state/brnpb/terraform.tfstate plan
```

## brclusterdev
```sh
terraform plan -var-file=state/brclusterdev/brclusterdev.tfvars -state=state/brclusterdev/terraform.tfstate -out plan.out
terraform apply -var-file=state/brclusterdev/brclusterdev.tfvars -state=state/brclusterdev/terraform.tfstate plan.out
rm -f ./plan.out
```
