# My Chats

Similar idea to [Nativefier](https://github.com/nativefier/nativefier), but just the way I like it 😀.

To change apps you plan to install modify ```myApplist/applist.txt``` and add the required png with the same name in lowercase.

## Install

Requires ```nodejs```

```
# Navigate to folder to directory where you want apps to live

git clone https://github.com/connbrack/my-chat-app.git
cd my-chat-app
cd appMaster
npm install 
cd ..
bash create_apps.sh
```
This script writes folder location into the created apps, and creates a symbolic link of the desktop files to ```~/.local/share/applications/```. If you move the folder delete the linked desktop files and all apps in "myApps" folder and rerun ```create_apps.sh```.
