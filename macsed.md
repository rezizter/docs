# Running sed on MacOS

## Introduction
When running sed on a Macbook I get the follwoing error

```bash
sed -i "s/true/false/g" myfile
```

!!! warning
    sed: 1: "Library/Group Container ...": invalid command code L

## Solution

The -i option expects an extension argument so the command above
is actually parsed as the extension argument and the file path is interpreted as the command code.

Adding the -e argument explicitly and giving '' as argument to -i:

```bash
sed -i '' -e "s/true/false/g" myfile
```
