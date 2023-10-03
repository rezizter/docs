# Red Alert 2 Menu not loading with Wine

## Introduction
We will go through the steps of fixing the Red Alert 2
menu not loading on wine
![image](./img/ra2_noload.png){: style="width:80:px"}

## Fix
* Download [cnc-ddraw](https://github.com/CnCNet/cnc-ddraw/releases/download/v4.4.7.0/cnc-ddraw.zip)
* Extract the zip file in the RA2's directory

open your terminal and type in:
```bash
winecfg
```
Click on "Libraries" and in New overrides for library type in "ddraw" and then click on Add
![image](./img/ra2_noload_1.png){: style="width:80:px"}

You will get a warning click on "Yes"
![image](./img/ra2_noload_2.png){: style="width:80:px"}

Click on Apply and then ok. You can now launch the game.


