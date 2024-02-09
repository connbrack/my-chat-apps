# My Chats

Similar idea to [Nativefier](https://github.com/nativefier/nativefier), but just the way I like it 😀.

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
This script also creates a symbolic link of the desktop file to ```~/.local/share/applications/``` if you move ththe folder the symbolic links will have to be deleted remade.

To change apps you plan to install modify ```myApplist/applist.txt``` and add the required png with the same name in lowercase.
