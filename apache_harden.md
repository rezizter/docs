# Secure apache on CentOS

We use mod_security to help secure apache and harden your webserver.

Install mod_security with:

```bash
yum install mod_security -y
```

Download rules:
```bash
yum -y install mod_security_crs
```

Now configure:
```bash
vi /etc/httpd/conf/httpd.conf
```

Add:
```bash
ServerTokens Prod
ServerSignature Off
<IfModule security2_module>
    SecRuleEngine on
    ServerTokens Min
    SecServerSignature " "
</IfModule>
```

Restart Apache to apply
```bash
systemctl restart httpd
```

Configure and secure php
```bash
sed -i 's/;date.timezone =/date.timezone = Africa\/Johannesburg/g' /etc/php.ini

sed -i 's/expose_php = On/expose_php = Off/g' /etc/php.ini

sed -i 's/max_execution_time = 30/max_execution_time = 180/g' /etc/php.ini

sed -i 's/; max_input_vars = 1000/max_input_vars = 10000/g' /etc/php.ini

sed -i 's/memory_limit = 128M/memory_limit = 256M/g' /etc/php.ini

sed -i 's/post_max_size = 8M/post_max_size = 32M/g' /etc/php.ini

sed -i 's/upload_max_filesize = 2M/upload_max_filesize = 32M/g' /etc/php.ini
```
