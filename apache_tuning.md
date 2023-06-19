# Speed up Apache 2.4 on CentOS8

## Introduction
We will go through the basic steps of speeding up your site running Apache 2.4 on a CentOS 8 server

## Setup

```bash
yum install httpd
```

Now add cache settngs to your global config

```bash
vi /etc/httpd/conf/httpd.conf
```

!!! note
    Add to the bottom of the file
    
```bash
#Set caching on image files for 11 months
<filesMatch "\.(ico|json|gif|jpg|png|txt|html)$">
  SetOutputFilter DEFLATE
  ExpiresActive On
  ExpiresDefault "access plus 11 month"
  Header append Cache-Control "public"
</filesMatch>
<filesMatch "\.(css|js)$">
  ExpiresActive On
  ExpiresDefault "access plus 1 week"
  Header append Cache-Control "public"
</filesMatch>
```

Now restart apache to apply the settings

```bash
systemctl restart httpd
```

## Test

Go to the site below and check your sites speed:

!!! note
    https://pagespeed.web.dev
