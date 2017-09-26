# Terraform packstack

Run:

```
source ./openrc
cd ./terraform
terraform init
terraform apply -var 'floating_ip=<public_ip>' -var 'external_net_id=<external_net_uuid>'
```

Connect:

```
ssh -F ../ansible/ssh_config api
```