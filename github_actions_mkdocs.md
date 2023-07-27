# Deploy mkdocs to a Remote server via ssh using Github Actions

## Introduction

I use Github to store my code for this documentation.
It is served using mkdocs.
I needed a way to auto deploy when I pushed changes
and found GitHub Actions was good for this.

## Setup

Create the workflow folder in your project
```bash
mkdir -p .github/workflow
```

Now create a deploy file
```bash
vi .github/workflow/deploy.yml
```

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

Now go to your project on Github

Click on Actions >  set up a workflow yourself


![image](./img/actions1.png){: style="width:80:px"}




