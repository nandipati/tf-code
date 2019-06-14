## A singleton bucket across all br enviroments

There is no brnpb/brnpa/brcoredev since there's intended to be only one
of these buckets. Therefore the state file can be right here in the
current directory, so the commands are just:

```
terraform plan
terraform apply
```
