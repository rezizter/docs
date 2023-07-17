# Errors when running molecule

## systemd error on Centos7

!!! warning
    fatal: [instance]: FAILED! => {"changed": false, "msg": "failure 1 during daemon-reload: Failed to get D-Bus connection: No such file or directory\n"}

## docker error

```bash
fatal: [instance]: UNREACHABLE! => {"changed": false, "msg": "Failed to create temporary directory. In some cases, you may have been able to authenticate and did not have permissions on the target directory. Consider changing the remote tmp path in ansible.cfg to a path rooted in \"/tmp\", for more error information use -vvv. Failed command was: ( umask 77 && mkdir -p \"` echo ~/.ansible/tmp `\"&& mkdir \"` echo ~/.ansible/tmp/ansible-tmp-1688585242.1362-34934-50098879611059 `\" && echo ansible-tmp-1688585242.1362-34934-50098879611059=\"` echo ~/.ansible/tmp/ansible-tmp-1688585242.1362-34934-50098879611059 `\" ), exited with result 1", "unreachable": true}
```

to fix this error run the following

```bash
molecule destroy
molecule converge
```


