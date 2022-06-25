# Build a Zerotier Server
Run the following
## Base Install
```bash
curl -s https://install.zerotier.com | sudo bash
yum install https://download.key-networks.com/el7/ztncui/1/ztncui-release-1-1.noarch.rpm -y
yum install ztncui -y
```
## Setup ssl certificates using letsencrypt
```bash
yum install epel-release
yum install httpd mod_ssl python-certbot-apache certbot jpeginfo -y

certbot --apache -d shaunmegaw.co.za
```
Setup cron
```bash
crontab -e

30 2 * * 1 /usr/bin/certbot renew >> /var/log/le-renew.log
```
Add the certificates
```bash
cd /opt/key-networks/ztncui/etc/tls
rm -f *.pem
ln -s /etc/letsencrypt/live/[network_controller_fqdn]/fullchain.pem fullchain.pem
ln -s /etc/letsencrypt/live/[network_controller_fqdn]/privkey.pem privkey.pem
chown ztncui /etc/letsencrypt/ -R
```

## Setup ports
```bash
sh -c "echo 'HTTPS_PORT=3443' > /opt/key-networks/ztncui/.env"
sh -c "echo 'HTTP_ALL_INTERFACES=yes' >> /opt/key-networks/ztncui/.env"

systemctl restart ztncui
```

http://shaunmegaw.co.za:3000

username: admin

password: password

