# Setup LetsEncrypt

We will go through the steps of setting up your own lets encrypt ssl Certificates

## Before you start
You will need a basoic web server with a fully qualified domain name setup.
You will need a virtual host for each certificate, eg: shaunmegaw.co.za and git.shaunmegaw.co.za

!!! note
    change shaunmegaw.co.za to your domain name

To set this up do the following
``` bash
yum install httpd mod_ssl -y
```
Now setup an apache virtual host file
```bash
vi /etc/httpd/conf.d/shaunmegaw.conf
```
Add
```bash
<VirtualHost *:80>
    DocumentRoot "/var/www/html/docs/site"
    ServerName shaunmegaw.co.za
    ServerAlias shaunmegaw.co.za

<Directory "/var/www/html/docs/site">
        DirectoryIndex index.php index.html
        Order allow,deny
        Allow from all
</Directory>
</VirtualHost>
```
Restart apache to apply
```bash
systemctl restart httpd
systemctl enable httpd
```

!!! note
    Repeat the virtual host setup for every sub domain as well

# Setup LetsEncrypt
Now we will go through the steps for creating a certificate
```bash
yum install epel-release

yum install httpd mod_ssl python-certbot-apache certbot jpeginfo -y
```

!!! note 
    each domain or subdomain is seperated by -d somename.domain.com

```bash
certbot --apache -d shaunmegaw.co.za -d wedding.shaunmegaw.co.za -d wiki.shaunmegaw.co.za
```
Now addto cron to automatically renew
```bash
crontab -e
```
Add the following
```bash
30 2 * * 1 /usr/bin/certbot renew >> /var/log/le-renew.log
```
