# Build A Murur Server

We will go through the steps of setting up a murmur server

## Basic Setup

### Install 

```bash
yum install git wget redhat-lsb-core -y
cd /tmp/
wget https://github.com/mumble-voip/mumble/releases/download/1.3.0/murmur-static_x86-1.3.0.tar.bz2
tar -vxjf ./murmur-static_x86-1.3.0.tar.bz2
mkdir /usr/local/murmur
cp -r ./murmur-static_x86-1.3.0/* /usr/local/murmur/
cp ./murmur-static_x86-1.3.0/murmur.ini /etc/murmur.ini
groupadd -r murmur
useradd -r -g murmur -m -d /var/lib/murmur -s /sbin/nologin murmur
mkdir /var/log/murmur
chown murmur:murmur /var/log/murmur
chmod 0770 /var/log/murmur
touch /var/log/murmur/murmur.log
mkdir /var/run/murmur/
touch /var/run/murmur/murmur.pid
chmod 0770 /var/run/murmur
chown murmur /var/run/murmur/ -R
chown murmur /var/log/murmur/ -R
```
### Configure

Create a basic config file

```bash
vi /etc/murmur.ini
```

Add the following to the bottom of the config file

```bash
database=/var/lib/murmur/murmur.sqlite
logfile=/var/log/murmur/murmur.log
pidfile=/var/run/murmur/murmur.pid
```

### Setup systemd

Create the following file
```bash
vi /etc/systemd/system/murmur.service
```

Add the following
```bash
[Unit]
Description=Mumble Server (Murmur)
Requires=network-online.target
After=network-online.target mariadb.service time-sync.target

[Service]
User=murmur
Type=forking
ExecStart=/usr/local/murmur/murmur.x86 -ini /etc/murmur.ini
PIDFile=/var/run/murmur/murmur.pid
ExecReload=/bin/kill -s HUP $MAINPID

[Install]
WantedBy=multi-user.target
```

To regenerate the pid directory for murmur, create the configuration file

```bash
vi /etc/tmpfiles.d/murmur.conf
```

Then add the following

```bash
d /var/run/murmur 775 murmur murmur
```

### Logrotate
To stop your server from running out of space, use logrotate
```bash
vi /etc/logrotate.d/murmur
```
Add the following

```bash
/var/log/murmur/*log {
    su murmur murmur
    dateext
    rotate 4
    missingok
    notifempty
    sharedscripts
    delaycompress
    postrotate
        /bin/systemctl reload murmur.service > /dev/null 2>/dev/null || true
    endscript
}
```
### Finishing up
start and enable
```bash
systemd-tmpfiles --create /etc/tmpfiles.d/murmur.conf
systemctl daemon-reload
systemctl start murmur.service
systemctl enable murmur.service
```

# Adding SSL
## Setup letsencrypt

[Install LEtsEncrypt](../letsencrypt/)

Now add the certificates to murmur

```bash
vi /etc/murmur.ini
```

Add the following to the bottom of the config file

!!! note
    Remember to replace shaunmegaw.co.za with your domain name

```bash
sslCert=/etc/letsencrypt/live/shaunmegaw.co.za/fullchain.pem
sslKey=/etc/letsencrypt/live/shaunmegaw.co.za/privkey.pem
```
Set permisions to certs
```bash
chmod a+rwx /etc/letsencrypt/archive/ -R
chmod a+rwx /etc/letsencrypt/live/ -R
```
Restart murmur to apply
```bash
systemctl restart murmur.service
systemctl enable murmur.service
```
!!! note
    Hi Zen
