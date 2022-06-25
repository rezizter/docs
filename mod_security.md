# mod Security for Apache
## Introduction
We will go through the steps of securing apache

## Disable showing server

```bash
curl -I https://shaunmegaw.co.za
```

It shows the server is running apache, we dont want this

```bash
HTTP/1.1 200 OK
Date: Thu, 10 Dec 2020 10:43:02 GMT
Server: Apache
Last-Modified: Fri, 27 Nov 2020 12:41:46 GMT
ETag: "5980-5b515fbbfce44"
Accept-Ranges: bytes
Content-Length: 22912
Vary: Accept-Encoding,User-Agent
yourip: 197.185.107.246
Content-Type: text/html; charset=UTF-8
```

Install mod security

```bash
yum install mod_security -y
```
Add the following

```bash
cat >> /etc/httpd/conf/httpd.conf << EOF
RemoteIPHeader X-Client-IP
RemoteIPHeader X-Forwarded-For
Header add yourip "%{REMOTE_ADDR}s"
<IfModule security2_module>
    SecRuleEngine on
    ServerTokens Full
    SecServerSignature " girl has no name "
</IfModule>
EOF
```

Restart apache to apply

```bash
service httpd restart
```
