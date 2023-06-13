# send_pubkey_test: no mutual signature algorithm

## Introduction
- This occurs when upgrading MacOS to Ventura 13.3.
- The symptoms are you are unable to ssh using your private key to some of your servers

## Why
- The RSA SHA-1 hash algorithm is being quickly deprecated across operating systems and SSH clients because of various security vulnerabilities, with many of these technologies now outright denying the use of this algorithm.

## Workaround

```bash
vi ~/.ssh/config
```

Add the following

```bash
PubkeyAcceptedKeyTypes +ssh-rsa
```

## Long term fix

You should re generate your ssh keys with ed25519

```bash
ssh-keygen -t ed25519 -C "your_email@example.com"
```
