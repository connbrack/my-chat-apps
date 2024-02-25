#/bin/bash/

app_dir="${PWD}/myApps/"
app_dir_esc=$(echo "$app_dir" | sed -e 's/\//\\\//g')


if [ ! -d "$app_dir" ]; then
    mkdir -p "$app_dir"
    echo "Directory created: $app_dir"
fi


while IFS= read -r line; do

    appName=$(echo "$line" | cut -d ',' -f 1)
    url=$(echo "$line" | cut -d ',' -f 2)
    url_esc=$(echo "$url" | sed -e 's/\//\\\//g')
    appNameLowercase=${appName,,}

    if [ -d "${app_dir}/${appNameLowercase}" ]; then
      echo "${appName} already exists"

    else
      echo "Creating ${appName}"
      
      cp -r appMaster/ myApps/$appNameLowercase/
      cp -f myApplist/$appNameLowercase.png myApps/$appNameLowercase/icon.png

      cd myApps/$appNameLowercase    

      sed -i "s/name__of__app__/${appName}/g" main.js 
      sed -i "s/https:\/\/example.com\//${url_esc}/g" main.js 

      sed -i "s/name__of__app_lc__/${appNameLowercase}/g" package.json

      sed -i "s/path__to__dir__/${app_dir_esc}/g" run.sh
      sed -i "s/name__of__app_lc__/${appNameLowercase}/g" run.sh

      sed -i "s/path__to__dir__/${app_dir_esc}/g" template.desktop
      sed -i "s/name__of__app__/${appName}/g" template.desktop
      sed -i "s/name__of__app_lc__/${appNameLowercase}/g" template.desktop
      
      mv template.desktop $appNameLowercase.desktop

      ln -s $app_dir/$appNameLowercase/$appNameLowercase.desktop $HOME/.local/share/applications/myChats_$appNameLowercase.desktop 

      cd $app_dir
      cd ..

    fi

done < "myApplist/applist.txt"
