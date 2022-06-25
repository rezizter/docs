# Change mysql Directory of percona 8 Cluster

!!! warning
    Only change the config file on one server at a time, if you change it on all of them your cluster will break
    change one, sync, then move onto the next

## Introducrtion
Percona cluster has a ton of advantages, least of which is the ability to rebuild and change a node then add it back, and all data is synced back.

We will go through the steps of changing the data directory and pid file
I needed this for the way we monitor filesystems and pid's

## Disable plugins

It will reinitialize the database, so you will need to disable your plugins like **audit_log_policy** and **validate_password_policy**

!!! note 
    change the config file to your config file location and name

```bash
sed -i 's/audit_log_policy/#audit_log_policy/g' /etc/my.cnf.d/db03.my3311.cnf
sed -i 's/validate_password_policy/#validate_password_policy/g' /etc/my.cnf.d/db03.my3311.cnf
```

## Change config

Change you config as needed. In my case i wanted to change the database directories, pid and sock file names and locations

```bash
server-id=2
port                          = 3311
datadir                       = /data/3311/mysql
socket                        = /data/3311/mysql/mysql.sock
log-error                     = /var/log/mysqld_3311.log
pid-file                      = /data/3311/mysql/mysqld.pid
user                          = mysql
```

TO

```bash

[mysqld]
server-id=3
port                          = 3311
datadir                       = /data/3311/mysql11
socket                        = /data/3311/mysql11/mysql11.sock
log-error                     = /var/log/mysqld_3311.log
pid-file                      = /data/3311/mysql11/mysqld11.pid
user                          = mysql
```

## Apply

stop your database

```bash
systemctl stop mysql
```

Now delete the database

```bash
rm -rf /data/3311/mysql
```

Start mysql, which will sync from one of the other nodes

```bash
systemctl start mysql
```

Once it starts, your database will be syned, but now you will need to re enable all your plugins

# Enable Plugins

```bash
sed -i 's/#audit_log_policy/audit_log_policy/g' /etc/my.cnf.d/db03.my3311.cnf
sed -i 's/#validate_password_policy/validate_password_policy/g' /etc/my.cnf.d/db03.my3311.cnf
```
Restart to apply:

```bash
systemctl restart mysql
```

## Apply to the rest of the cluster

Re run the steps on each cluster
