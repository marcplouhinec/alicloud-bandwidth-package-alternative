# Alibaba Cloud Bandwidth Package Alternative

```shell script
export ALICLOUD_ACCESS_KEY="your-accesskey-id"
export ALICLOUD_SECRET_KEY="your-accesskey-secret"
ECS_ROOT_PASSWORD="YourSecretR00tPassword"

# Create the Hong Kong machine
cd cn-hongkong
export ALICLOUD_REGION="cn-hongkong" # Note: use ap-southeast-1 for Singapore

terraform init
terraform apply -var "ecs_root_password=$ECS_ROOT_PASSWORD"
export HK_ECS_IP_ADDRESS=`terraform output hk_ecs_ip_address`

# Create the Shenzhen machine
cd ../cn-shenzhen
export ALICLOUD_REGION="cn-shenzhen"

terraform init
terraform apply -var "ecs_root_password=$ECS_ROOT_PASSWORD" \
                -var "hk_ecs_ip_address=$HK_ECS_IP_ADDRESS"
export SZ_ECS_IP_ADDRESS=`terraform output sz_ecs_ip_address`

echo "Shenzhen ECS IP address: $SZ_ECS_IP_ADDRESS"
```

To destroy everything:
```shell script
export ALICLOUD_ACCESS_KEY="your-accesskey-id"
export ALICLOUD_SECRET_KEY="your-accesskey-secret"
ECS_ROOT_PASSWORD="YourSecretR00tPassword"

cd cn-shenzhen
export ALICLOUD_REGION="cn-shenzhen"
terraform destroy

cd ../cn-hongkong/
export ALICLOUD_REGION="cn-hongkong"
terraform destroy
```