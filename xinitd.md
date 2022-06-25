# Port Forward on Linux with xinitd

## Introdcution

I need a service listening on port 443 and forwarding this traffic to port 6061.

## Setup

Install xinitd

```bash
yum install xinetd
```

Setup the config file

vi /etc/xinetd.d/http-switch
```bash
service http-switch
{
 disable = no
 type = UNLISTED
 socket_type = stream
 protocol = tcp
 wait = no
 redirect = 127.0.0.1 6061
 bind = 0.0.0.0
 port = 443
 user = nobody
}
```

service xinetd restart
