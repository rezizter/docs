# Secure Asterisk

## Introduction

## Change the user agent

Changing the User agent means that the attacker will
use the incorrect scripts to attack your system.

Open your pjsip.conf file

```
vi /etc/asterisk/pjsip.conf
```
Now add
```bash
[global]
user_agent=MicrosoftXP/IOS-12.x
```
Reload your config to apply
```
asterisk -vvvr
core reload
```
Now if someone scans your system the output will be as follows:
```
+----------------------+----------------------+-------------+
| SIP Device           | User Agent           | Fingerprint |
+======================+======================+=============+
| 102.145.163.239:5060 | MicrosoftXP/IOS-12.x | disabled    |
+----------------------+----------------------+-------------+
```

## IPTables scripts

This script will scan the asterisk logs and add the IP addresses of failed logins to iptables.

Enable logging in Asterisk:

```
vi /etc/asterisk/logger.conf
```
Add this line:

```bash
messages = notice,warning,error
security = security
```
Reload the asterisk config

```bash
asterisk -vvvr
core reload
```

Now create the script:

```bash
mkdir /opt/scripts

vi /opt/scripts/sip_lock.sh
```

Add the following:

!!! note
    Replace 192.168.0. with your network range
    so that you don't block your own devices.
    
```bash
#!/bin/bash

grep "Failed to authenticate"  /var/log/asterisk/messages | cut -d ' ' -f14 | sed 's/:5060//g' | sed "s/'//g" | cut -d ':' -f1 | grep -v "192.168.0.\|callid" | uniq > /tmp/lock.txt
grep "No matching endpoint found"  /var/log/asterisk/messages | cut -d ' ' -f13,14 | cut -d ':' -f1 | sed "s/'//g" | grep -v "192.168.0.\|callid" | uniq >> /tmp/lock.txt

for x in $(cat /tmp/lock.txt)
do
    iptables -A INPUT -s $x -p tcp --dport 5060 -j DROP
    iptables -A INPUT -s $x -p udp --dport 5060 -j DROP
done

# Clear the log
> /var/log/asterisk/messages

# Reload
asterisk -rx "core reload"
```

Set the permissions:

```bash
chmod +x /opt/scripts/sip_lock.sh
```
Now add the script to cron

```
crontab -e
```
Add:

```bash
10 20 * * * /opt/scripts/sip_lock.sh
10 04 * * * /opt/scripts/sip_lock.sh
```
