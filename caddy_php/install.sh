#!/bin/bash

# Define wwwroot & domain (You can change here)
wwwroot="/www"
read -p "Please input your domain: " _domain

# Install PHP7.3
apt-get update
apt-get install curl wget php7.3-sqlite3 php7.3-fpm php7.3-curl php7.3 sqlite3 php7.3-gd php7.3-mbstring php7.3-xml -y
systemctl enable php7.3-fpm
systemctl restart php7.3-fpm

# Install Caddy 1.0.4
wget --no-check-certificate https://github.com/hjh142857/scripts/raw/master/caddy_php/caddy
wget --no-check-certificate https://github.com/hjh142857/scripts/raw/master/caddy_php/caddy.service
wget --no-check-certificate https://github.com/hjh142857/scripts/raw/master/caddy_php/Caddyfile
chmod +x caddy
mv caddy /usr/local/bin/
mv caddy.service /etc/systemd/system/
mv Caddyfile /usr/local/bin/
sed -i "s#\/www#$wwwroot#g" /usr/local/bin/Caddyfile
sed -i "s#your_domain.com#$_domain#g" /usr/local/bin/Caddyfile
systemctl enable caddy
systemctl restart caddy

# Add www-data group & user
groupadd www-data
useradd --shell /sbin/nologin -g www-data www-data

# Create wwwroot folder
rm -rf ${wwwroot}
mkdir ${wwwroot}
chown www-data:www-data -R ${wwwroot}
chmod -R 777 ${wwwroot}

# Print Install Infomation
echo "=============================================================="
echo "                The wwwroot is ${wwwroot}                     "
echo "     The caddy config file is /usr/local/bin/Caddyfile        "
echo "=============================================================="
