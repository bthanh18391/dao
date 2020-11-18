#!/bin/bash
sudo systemctl stop squid
sudo rm /etc/squid/squid.conf
sudo tee /etc/squid/squid.conf > /dev/null <<EOF

#password
auth_param basic program /usr/lib64/squid/basic_ncsa_auth /usr/lib64/squid/passwords
acl ncsa_users proxy_auth REQUIRED
#http_access allow authen_user
http_access allow ncsa_users
#acl to_ipv6 dst ipv6
dns_nameservers 8.8.8.8 208.67.222.222 2001:4860:4860::8888
#acl to_ipv4 dst ipv4
#http_access deny to_ipv4
dns_v4_first off
http_port 8121
http_port 8122
http_port 8123
http_port 8124
http_port 8125
http_port 8126
http_port 8127
http_port 8128
acl v401 myportname 8121
acl v601 myportname 8122
acl v602 myportname 8123
acl v603 myportname 8124
acl v604 myportname 8125
tcp_outgoing_address $(ip addr show eth0 | grep 'scope global dynamic eth0' | awk '{print $2}' | cut -f1 -d'/') v401
tcp_outgoing_address 2001:4860:4860::8888 v401
tcp_outgoing_address 8.8.8.8 v601
tcp_outgoing_address 8.8.8.8 v602
tcp_outgoing_address 8.8.8.8 v603
tcp_outgoing_address 8.8.8.8 v604
tcp_outgoing_address $(ip addr show eth0 | grep '128 scope global dynamic' | awk '{print $2}' | cut -f1 -d'/' | head -1) v601
tcp_outgoing_address $(ip addr show eth0 | grep '128 scope global dynamic' | awk '{print $2}' | cut -f1 -d'/' | tail -1) v602
tcp_outgoing_address $(ip addr show eth1 | grep '128 scope global dynamic' | awk '{print $2}' | cut -f1 -d'/' | head -1) v603
tcp_outgoing_address $(ip addr show eth1 | grep '128 scope global dynamic' | awk '{print $2}' | cut -f1 -d'/' | tail -1) v604
http_access deny all
coredump_dir /var/cache/squid
refresh_pattern ^ftp:           1440    20%     10080
refresh_pattern ^gopher:        1440    0%      1440
refresh_pattern -i (/cgi-bin/|\?) 0     0%      0
refresh_pattern .               0       20%     4320
max_filedescriptors 3200
### Deny headers
request_header_access Via deny all
request_header_access Forwarded-For deny all
request_header_access X-Forwarded-For deny all
reply_header_access Via deny all
reply_header_access Server deny all
reply_header_access WWW-Authenticate deny all
request_header_access Authorization allow all
request_header_access Proxy-Authorization allow all
request_header_access Cache-Control allow all
request_header_access Content-Length allow all
request_header_access Content-Type allow all
request_header_access Date allow all
request_header_access Host allow all
request_header_access If-Modified-Since allow all
request_header_access Pragma allow all
request_header_access Accept allow all
request_header_access Accept-Charset allow all
request_header_access Accept-Encoding allow all
request_header_access Accept-Language allow all
request_header_access Connection allow all
request_header_access All deny all
reply_header_access Allow allow all
reply_header_access WWW-Authenticate allow all
reply_header_access Proxy-Authenticate allow all
reply_header_access Content-Encoding allow all
reply_header_access Content-Type allow all
reply_header_access Expires allow all
reply_header_access Last-Modified allow all
reply_header_access Location allow all
reply_header_access Content-Language allow all
reply_header_access Retry-After allow all
reply_header_access Title allow all
reply_header_access Content-Disposition allow all
EOF
sudo  bash -c 'cat <<EOT >>/lib/systemd/system/proxy.service 
[Unit]
Description=proxy
After=network.target
[Service]
Type=forking
ExecStart=/usr/sbin/squid
WatchdogSec=1800
Restart=always
RestartSec=35
User=root
[Install]
WantedBy=multi-user.target
EOT
'
sudo systemctl daemon-reload
sudo systemctl enable proxy.service
sudo service proxy start
