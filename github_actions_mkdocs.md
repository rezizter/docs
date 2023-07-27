# Deploy mkdocs to a Remote server via ssh using Github Actions

## Introduction

I use Github to store my code for this documentation.
It is served using mkdocs.
I needed a way to auto deploy when I pushed changes
and found GitHub Actions was good for this.

## Setup

### SSH Keys
Generate ssh keys.

```bash
ssh-keygen -b 4096
```

Add the public key to your servers authorized_keys

```bash
vi .ssh/authorized_keys
```

### Setup Secrets
On the Github site you need to setup your secrets.
Go to:

!!! note
    https://github.com/USERNAME/REPO/settings/secrets
    
Replace USERNAME/REPO with your repo username.

Click on "New repository secrets"
![image](./img/actions2.png){: style="width:80:px"}

Create a HOST secret:

Name: HOST
Secret: your server name or ip:
![image](./img/actions3.png){: style="width:80:px"}

Now create a PRIVATE_KEY secret:

Name: PRIVATE_KEY
Secret: copy in your ssh private key
![image](./img/actions4.png){: style="width:80:px"}

### Setup Action
Now go to your project on Github

Click on Actions >  set up a workflow yourself
![image](./img/actions1.png){: style="width:80:px"}

Add the following:
```bash
name: Deploy mkdocs via ssh

on: push

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
      - name: ls -a via OPEN SSH Private Key
        uses: garygrossgarten/github-action-ssh@release
        with:
          command: ls -a
          host: ${{ secrets.HOST }}
          username: root
          privateKey: ${{ secrets.PRIVATE_KEY}}
        env:
          CI: true
```
![image](./img/actions5.png){: style="width:80:px"}

