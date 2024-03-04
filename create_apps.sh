#/bin/bash/

app_dir="${PWD}/myApps/"
app_dir_esc=$(echo "$app_dir" | sed -e 's/\//\\\//g')


if [ ! -d "$app_dir" ]; then
    mkdir -p "$app_dir"
fi


while IFS= read -r line; do

    appName=$(echo "$line" | cut -d ',' -f 1)
    url=$(echo "$line" | cut -d ',' -f 2)
    url_esc=$(echo "$url" | sed -e 's/\//\\\//g')
    appNameLowercase=${appName,,}

    echo; echo 
    echo "###### Creating ${appName}"
    echo; echo 
    
    cp -r appMaster/ myApps/$appNameLowercase/
    cp -f myApplist/$appNameLowercase.png myApps/$appNameLowercase/icon/256x256.png

    cd $app_dir/$appNameLowercase    

    sed -i "s/name__of__app__/${appName}/g" main.js 
    sed -i "s/https:\/\/example.com\//${url_esc}/g" main.js 

    sed -i "s/name__of__app__/${appName}/g" package.json
    sed -i "s/name__of__app_lc__/${appNameLowercase}/g" package.json

    npm install
    npm run dist

    cd dist
    sudo apt install --reinstall ./*.deb

    cd $app_dir
    cd ..

done < "myApplist/applist.txt"

rm -r $app_dir
