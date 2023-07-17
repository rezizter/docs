# Test Ansible role with Molecule on Macos

## Introduction
We will go through the steps of creating a molecule test for your role.
This will test a roll for CentOS7 on MacOS.

## Setup

### Install Docker on your mac

```bash
softwareupdate --install-rosetta
brew install --cask docker
open /Applications/Docker.app
```

### Create role with molecule

```bash
molecule init role --driver-name docker <ROLE_NAME>
```


## Notes

### Set Cgroup Version to 1

```bash
sed -i '' -e 's/"deprecatedCgroupv1": false/"deprecatedCgroupv1": true/g' Library/Group\ Containers/group.com.docker/settings.json
```

Restart Docker

```bash
killall Docker
open /Applications/Docker.app
```
