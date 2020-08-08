// Alibaba Cloud provider (source: https://github.com/terraform-providers/terraform-provider-alicloud)
provider "alicloud" {}

// VPC and VSwitch
resource "alicloud_vpc" "hongkong_vpc" {
  name = "hongkong-vpc"
  cidr_block = "192.168.0.0/16"
}
data "alicloud_zones" "az" {
  network_type = "Vpc"
  available_instance_type = var.ecs_instance_type
}
resource "alicloud_vswitch" "hongkong_vswitch" {
  name = "hongkong-vswitch"
  availability_zone = data.alicloud_zones.az.zones[0].id
  cidr_block = "192.168.0.0/24"
  vpc_id = alicloud_vpc.hongkong_vpc.id
}

// Security group and rules
resource "alicloud_security_group" "hongkong_security_group" {
  name = "hongkong-security-group"
  vpc_id = alicloud_vpc.hongkong_vpc.id
}
resource "alicloud_security_group_rule" "accept_22_rule" {
  type = "ingress"
  ip_protocol = "tcp"
  nic_type = "intranet"
  policy = "accept"
  port_range = "22/22"
  priority = 1
  security_group_id = alicloud_security_group.hongkong_security_group.id
  cidr_ip = "0.0.0.0/0"
}
resource "alicloud_security_group_rule" "accept_80_rule" {
  type = "ingress"
  ip_protocol = "tcp"
  nic_type = "intranet"
  policy = "accept"
  port_range = "80/80"
  priority = 1
  security_group_id = alicloud_security_group.hongkong_security_group.id
  cidr_ip = "0.0.0.0/0"
}
resource "alicloud_security_group_rule" "accept_17403_rule" {
  type = "ingress"
  ip_protocol = "tcp"
  nic_type = "intranet"
  policy = "accept"
  port_range = "17403/17403"
  priority = 1
  security_group_id = alicloud_security_group.hongkong_security_group.id
  cidr_ip = "0.0.0.0/0"
}

// Latest supported Debian image
data "alicloud_images" "debian_images" {
  owners = "system"
  name_regex = "debian"
  most_recent = true
}

// ECS instance
resource "alicloud_instance" "hongkong_instance_ecs" {
  instance_name = "hongkong-ecs"
  description = "Bandwidth Package Alternative (Hong Kong)."

  host_name = "hongkong-ecs"
  password = var.ecs_root_password

  image_id = data.alicloud_images.debian_images.images[0].id
  instance_type = var.ecs_instance_type
  system_disk_category = "cloud_ssd"
  system_disk_size = 20

  internet_max_bandwidth_out = var.ecs_max_bandwidth_out

  vswitch_id = alicloud_vswitch.hongkong_vswitch.id
  security_groups = [
    alicloud_security_group.hongkong_security_group.id
  ]

  user_data = file("resources/install.sh")
}