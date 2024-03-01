# Secure Asterisk

## Introduction

## Change the user agent

Changing the User agent means that the attacker will
user the incorect scripts to attack your system.

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

