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
| 192.168.0.239:5060   | MicrosoftXP/IOS-12.x | disabled    |
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

grep "Failed to authenticate"  /var/log/asterisk/messages | cut -d ' ' -f14 | sed 's/:5060//g' | sed "s/'//g" | cut -d ':' -f1 | grep -v "192.168.0\|callid\|)" | uniq > /tmp/brute.txt
grep "Failed to authenticate"  /var/log/asterisk/messages | cut -d ' ' -f12 | sed 's/:5060//g' | sed "s/'//g" | cut -d ':' -f1 | grep -v "192.168.0\|callid\|for\|failed" | uniq >> /tmp/brute.txt
grep "No matching endpoint found"  /var/log/asterisk/messages | cut -d ' ' -f13,14 | cut -d ':' -f1 | sed "s/'//g" | grep -v "192.168.0\|callid" | uniq >> /tmp/brute.txt

for address in `grep -v -f /tmp/applied_brute.txt < /tmp/brute.txt`; do
    echo $address >> /tmp/applied_brute.txt
    if ! grep -q -F -x $address /tmp/exclude_ipaddress.txt; then
        IPTABLE="/sbin/iptables -A INPUT -s "$address" -j DROP"
        echo $IPTABLE
        $IPTABLE
    fi
done

unset address
unset IPTABLE
```

Create files
```
touch /tmp/brute.txt
touch /tmp/applied_brute.txt
touch /tmp/exclude_ipaddress.txt
```

list of ip addresses you want to exclude from being blocked
```
vi /tmp/exclude_ipaddress.txt
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
0 * * * * /opt/scripts/sip_lock.sh
```
