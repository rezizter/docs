# M365-cli: Authenticate without a browser

## Introduction

We will go through the steps of using:
```bash
/usr/local/bin/m365 setup
```

On a remote linux server that is headless and has no browser.

## Setup

Open a terminal and ssh to your server.
Install npm using:
```bash
npm install -g @pnp/cli-microsoft365
```
Run the following command
```bash
/usr/local/bin/m365 setup --debug
```

You will get a url. Note the port number and then run a new ssh terminal
forwarding the port to your local machine:
!!! note
    In my example the port is 37651, howeever it is a random port each time

![image](./img/m365_url.png){: style="width:80:px"}

Forward your local port with:
```bash
ssh root@<yourserver> -L 37651:localhost:37651
```

Now copy the full link and paste it in your local browser to authenticate.



