# Alibaba Cloud Bandwidth Package Alternative
## Introduction
The goal of this project is to evaluate the performance of connecting
two [Alibaba Cloud](https://www.alibabacloud.com) servers located in different regions
without purchasing an expensive [bandwidth package](https://partners-intl.aliyun.com/help/doc-detail/65982.htm).

## Installation
If you don't have any, [create an Alibaba Cloud account](https://www.alibabacloud.com/help/doc-detail/50482.htm) and
[obtain an access key id and secret](https://www.alibabacloud.com/help/faq-detail/63482.htm).

In addition, please [install Terraform](https://learn.hashicorp.com/terraform/getting-started/install.html) on
your computer.

Open a terminal and execute the following commands:
```shell script
export ALICLOUD_ACCESS_KEY="your-accesskey-id"
export ALICLOUD_SECRET_KEY="your-accesskey-secret"
ECS_ROOT_PASSWORD="YourSecretR00tPassword"

# Create a machine in Hong Kong
cd cn-hongkong
export ALICLOUD_REGION="cn-hongkong"

terraform init
terraform apply -var "ecs_root_password=$ECS_ROOT_PASSWORD"
export HK_ECS_IP_ADDRESS=`terraform output hk_ecs_ip_address`

# Create a machine in Shenzhen
cd ../cn-shenzhen
export ALICLOUD_REGION="cn-shenzhen"

terraform init
terraform apply -var "ecs_root_password=$ECS_ROOT_PASSWORD" \
                -var "hk_ecs_ip_address=$HK_ECS_IP_ADDRESS"
export SZ_ECS_IP_ADDRESS=`terraform output sz_ecs_ip_address`

echo "Shenzhen ECS IP address: $SZ_ECS_IP_ADDRESS"
```
The script above creates two servers located in Hong Kong and Shenzhen, and connect them
with V2Ray. The Shenzhen machine can connect to the Hong Kong one via a local socks5 proxy on
the port 1080.

## Uninstallation
Open a terminal and execute the following commands:
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

