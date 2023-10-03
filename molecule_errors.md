# Errors when running molecule

## Skip molecule error using tags

Add the molecule-notest to your test in your role:

```bash
  tags: molecule-notest
```
## Systemd not working on Centos8

Error

```bash
fatal: [instance]: FAILED! => {"changed": false, "msg": "failure 1 during daemon-reload: Failed to connect to bus: No such file or directory\n"}
```

To fix this you need to change your molecule file as follows:

```bash
vi molecule/default/molecule.yml
```
Replace with:

```bash
---
dependency:
  name: galaxy
driver:
  name: docker
platforms:
  - name: instance
    image: geerlingguy/docker-centos8-ansible:latest
    command: /sbin/init
    volumes:
      - /sys/fs/cgroup:/sys/fs/cgroup:rw
    cgroupns_mode: host
    privileged: true
    pre_build_image: true
```

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


