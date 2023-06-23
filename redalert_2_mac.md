# Play Red Alert 2 on a Mac M1

## Introduction

I play Red Alert 2, and have been struggling to get it working on a mac with wine since they dropped support for 32 bit apps. I use a modified version of openra to play, which I found was great at giving me the added bonus of a "remastered" feel to the game.

![image](./img/ra2_ubuntu.png){: style="width:150:px"}

## Install

Install dotnet 6:

```bash
brew install dotnet@6
```

Now link the binary to your environment

```bash
sudo ln -s /opt/homebrew/opt/dotnet@6/bin/dotnet /usr/local/bin/dotnet
```

Install packages

```bash
brew install wget unzip sdl2 openal-soft freetype lua51
```

Now download OpenRA with the ra2 mod:

```bash
cd ~
wget "https://github.com/OpenRA/ra2/archive/master.zip"
unzip master.zip
cd ra2-master
make all
```

Create the game directory:

```bash
mkdir ~/Library/Application\ Support/OpenRA/Content/ra2
```

Copy the game files

!!! note
    Replace ~/Games/RedAlert2/ with the location of your RA2 files.

```bash
cp -r ~/Games/RedAlert2/* ~/Library/Application\ Support/OpenRA/Content/ra2/
```

Launch the game with

```bash
./launch-game.sh
```
