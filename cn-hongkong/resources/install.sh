#!/bin/bash
#
# Hong Kong machine installation script.
#

# Update the distribution
echo "Update distribution" >>/root/installation.log
export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get -y upgrade
apt-get -y install jq

# Install V2Ray
echo "Install V2Ray" >>/root/installation.log
wget https://install.direct/go.sh
bash go.sh

# Configure V2Ray
echo "Configure V2Ray" >>/root/installation.log
cp /etc/v2ray/config.json /etc/v2ray/config.json.bak
jq '.inbounds[0].port = 17403' /etc/v2ray/config.json >/etc/v2ray/config.next.json
rm -f /etc/v2ray/config.json
mv /etc/v2ray/config.next.json /etc/v2ray/config.json
jq '.inbounds[0].settings.clients[0].id = "8db88932-9cde-4a8e-82c5-fb15d90b0093"' /etc/v2ray/config.json >/etc/v2ray/config.next.json
rm -f /etc/v2ray/config.json
mv /etc/v2ray/config.next.json /etc/v2ray/config.json

# Start V2Ray
echo "Start V2Ray" >>/root/installation.log
systemctl start v2ray
systemctl enable v2ray

# Distribute V2Ray install package
echo "Distribute V2Ray install package" >>/root/installation.log
apt-get -y install apache2
wget https://install.direct/go.sh
cp /root/go.sh /var/www/html/
NEW_VER=$(curl https://api.github.com/repos/v2fly/v2ray-core/releases/latest | grep 'tag_name' | cut -d\" -f4)
DOWNLOAD_LINK="https://github.com/v2fly/v2ray-core/releases/download/${NEW_VER}/v2ray-linux-64.zip"
wget "$DOWNLOAD_LINK"
cp v2ray-linux-64.zip /var/www/html/
systemctl start apache2

echo "Installation script completed!" >>/root/installation.log
