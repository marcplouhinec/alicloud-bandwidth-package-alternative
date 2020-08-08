#!/usr/bin/env bash
#
# Shenzhen machine installation script.
#
# Arguments:
# Hong Kong ECS IP address
#

export HK_ECS_IP_ADDRESS="${hk_ecs_ip_address}"

# Update the distribution
echo "Update distribution" >>/root/installation.log
export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get -y upgrade
apt-get -y install jq

# Install V2Ray
echo "Install V2Ray" >>/root/installation.log
wget "http://$HK_ECS_IP_ADDRESS/go.sh"
wget "http://$HK_ECS_IP_ADDRESS/v2ray-linux-64.zip"
bash go.sh -l /root/v2ray-linux-64.zip

# Configure V2Ray
echo "Configure V2Ray (Hong Kong ECS IP address = $HK_ECS_IP_ADDRESS)" >>/root/installation.log
cp /etc/v2ray/config.json /etc/v2ray/config.json.bak
cd /etc/v2ray
jq '.inbounds[0].port = 1080' config.json >config.next.json && mv config.next.json config.json
jq '.inbounds[0].protocol = "socks"' config.json >config.next.json && mv config.next.json config.json
jq '.inbounds[0].sniffing = {"enabled": true,"destOverride": ["http", "tls"]}' config.json >config.next.json && mv config.next.json config.json
jq '.inbounds[0].settings = {"auth": "noauth"}' config.json >config.next.json && mv config.next.json config.json
jq '.outbounds = [{"protocol": "vmess", "settings": {}}]' config.json >config.next.json && mv config.next.json config.json
jq ".outbounds[0].settings.vnext[0] = {\"address\":\"$HK_ECS_IP_ADDRESS\"}" config.json >config.next.json && mv config.next.json config.json
jq '.outbounds[0].settings.vnext[0].port = 17403' config.json >config.next.json && mv config.next.json config.json
jq '.outbounds[0].settings.vnext[0].users = [{"id": "8db88932-9cde-4a8e-82c5-fb15d90b0093","alterId": 64}]' config.json >config.next.json && mv config.next.json config.json
jq '.routing = {}' config.json >config.next.json && mv config.next.json config.json

# Start V2Ray
echo "Start V2Ray" >>/root/installation.log
systemctl start v2ray
systemctl enable v2ray

echo "Installation script completed!" >>/root/installation.log
