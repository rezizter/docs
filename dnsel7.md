# DNS setup in el7

```bash
yum install bind bind-utils bind-libs bind-chroot caching-nameserver
```
Listen on your server ip:

!!! note
    replace 102.130.116.253 with your servers ip address.

```bash
sed -i 's/127.0.0.1/102.130.116.253/g' /etc/named.conf
```
Allow anyone to query your dns server

```bash
sed -i 's/localhost/any/g' /etc/named.conf
```

Add the locations of your forward and reverse dns files to the main config file

!!! note
    the reverse zone is your servers ip addy reversed.
    My forward IP is 102.130.116.253
    Therefore my reverse is: 253.116.130.102
    Adjust below to match yours

!!! info
    change shaunmegaw.co.za to your domain name
    change 116.130.102 to your reverse ip (drop last notation)

```bash
vi /etc/named.conf.local
```

Add to the bottom

```bash
zone "shaunmegaw.co.za" {
   type master;
   file "/var/named/shaunmegaw.co.za";
};

zone "116.130.102.in-addr.arpa" {
   type master;
   file "/var/named/116.130.102.in-addr.arpa";
};
```

## Forward Zone

```bash
vi /var/named/shaunmegaw.co.za
```

add the following

!!! info
    change shaunmegaw.co.za to your domain name
    change 102.130.116.253 to your ip

```bash
i$TTL 1h
@       IN      SOA     shaunmegaw.co.za.    root.shaunmegaw.co.za. (
        2019080901      ; Serial YYYYMMDDnn
        24h             ; Refresh
        2h              ; Retry
        28d             ; Expire
        2d )            ; Minimum TTL

;Name Servers
@       IN      NS              dns

;Mail Servers
@       IN      MX      0       mail

;Other Servers
dns     IN      A               102.130.116.253
git     IN      A               102.130.116.253
mail    IN      A               102.130.116.253
web     IN      A               102.130.116.253

;Canonical Names
www     IN      CNAME           web
```

### Check the syntax of your forward zone.

```bash
named-checkzone shaunmegaw.co.za /var/named/shaunmegaw.co.za
```

## Reverse Zone

```bash
vi /var/named/116.130.102.in-addr.arpa
```

Add the following:

```bash
$TTL 1h
@       IN      SOA     116.130.102.in-addr.arpa    root.shaunmegaw.co.za. (
        2019080901      ; Serial YYYYMMDDnn
        24h             ; Refresh
        2h              ; Retry
        28d             ; Expire
        2d )            ; Minimum TTL

;Name Servers
@       IN      NS              dns

;Other Servers
dns     IN      A        102.130.116.253

;PTR Records
4               IN      PTR             dns
6               IN      PTR             mail
3               IN      PTR             web

```

### Check the syntax of your forward zone.

```bash
named-checkzone shaunmegaw.co.za /var/named/116.130.102.in-addr.arpa
```

## Permissions

```bash
chgrp named /var/named/shaunmegaw.co.za
chgrp named /var/named/116.130.102.in-addr.arpa
```

Start

```bash
systemctl enable --now named.service
systemctl status named
```

## Firewall rules

iptables

```bash
iptables -A OUTPUT -p udp -m udp --dport 53 -j ACCEPT
```

firewalld

```bash
firewall-cmd --permanent --add-service=dns
firewall-cmd --reload
```
