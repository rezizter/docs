# Brute force the admin password for a HIKVision DVR
![image](./img/hik_brute1.png){: style="width:80:px"}

## Introduction

We lost the admin password for a HIK vision DVR model number: DS-7104HGHI-F1.
We know the username is admin, so we needed to push through a list of passwords.

## Install scavenger

A brute force tool called scavenger is available to do this:

!!! note
    https://github.com/skavngr/scavenger

Install required packages:

```bash
gem install --user-install typhoeus

gem install --user-install colorize
```
!!! warning
    Replace xxx.xxx.xxx.xxx with the ip of your HIKVision dvr ip.

```bash
git clone https://github.com/skavngr/scavenger.git

cd scavenger

chmod +x skavngr.rb

sed -i 's/targetipaddressoftherouter/xxx.xxx.xxx.xxx/g' skavngr.rb

```
Now run the script:

```bash
./skavngr.rb
```

## Conclusion

Let this script run. It will take a few hours to reveal the password.
