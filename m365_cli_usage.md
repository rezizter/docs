# Microsoft m365-cli

# Installation
Install npm using:
```bash
npm install -g @pnp/cli-microsoft365
```

You may need to set the path:

```bash
vi ~/.bashrc
```

Add the following to the bottom

```bash
if [ -d "/usr/local/bin" ] ; then
  PATH="$PATH:/usr/local/bin"
fi
```
Now add to bash
```bash
source ~/.bashrc
```

# Login
!!! note
    These instructions are for a remote headless server without a browser.

Run the following command
```bash
m365 setup --debug
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

# Confirm credentials
Run:
```bash
m365 status
```

# Create a Microsoft Teams Group
## Create a group
Run the following:
```bash
m365 entra m365group add
```
Now type in a group name and team name
![image](./img/365_url_create_group.png){: style="width:80:px"}

## See the groups details
```bash
m365 entra m365group get
```
Under "Option to use:"
Select "displayName"

Now type in the groups name
![image](./img/365_url_view_group.png){: style="width:80:px"}

# Add users to a Teams group

!!! note
    You get the groupID from the step above
    Replace yourname.yoursurname@yourdomain.com with the users details

```bash
m365 entra m365group user add --groupId 100000aa-ea12-4b123-9a123-f1111111 --userNames "yourname.yoursurname@yourdomain.com" --role member
```

# Batch add users to a Teams group via csv

These instructions are for batch adding users from a csv file to your teams group on a Linux machine

Install powershell on hyour Linux box

!!! note
    This is for a Red hat based server

```bash
dnf install https://github.com/PowerShell/PowerShell/releases/download/v7.5.1/powershell-7.5.1-1.rh.x86_64.rpm
```

Create a csv file with the following details:

```bash
vi teams.csv
```

!!! note
    include the header UPN,teamName,teamId,role

!!! warning
    UPN,teamName,teamId,role
    name1.surname1@yourdomain.com,Teams_name,100000aa-ea12-4b123-9a123-f1111111,owner
    name2.surname2@yourdomain.com,Teams_name,100000aa-ea12-4b123-9a123-f1111111,member

Now create a MicroSoft BAT script:
```bash
vi script.bat
```

Add
!!! note
    Make sure the location of your csv file is referenced.
```bash
#Check if connected to M365
$m365Status = /usr/local/bin/m365 status --output text
if ($m365Status -eq "Logged Out") {
  /usr/local/bin/m365 login
}

#Import csv
$usersCsvFile = Import-Csv -Path "/root/teams.csv"

#Add users to the Team
foreach ($row in $usersCsvFile) {
  Write-Host "Adding $($row.UPN) to the $($row.teamName) Team" -ForegroundColor Magenta
  /usr/local/bin/m365 entra m365group user add --groupId $row.teamId --userNames "$($row.UPN)" --role $row.role
}
```

Now run the script to to add the users from your csv file to your teams group:
```bash
pwsh script.bat
```

## View the group in Microsoft Teams
Open teams, click on the chats and scroll to the bottom.
Click on "See all your teams"
![image](./img/365_teams_1.png){: style="width:80:px"}

Click on "Teams you own" and you should see it in the drop down
![image](./img/365_teams_2.png){: style="width:80:px"}
