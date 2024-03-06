#/bin/bash/

temp_dir="${PWD}/temp/"
appimage_dir="${PWD}/myApps/"


if [ ! -d "$temp_dir" ]; then
    mkdir -p "$temp_dir"
fi
if [ ! -d "$appimage_dir" ]; then
    mkdir -p "$appimage_dir"
fi


while IFS= read -r line; do

    appName=$(echo "$line" | cut -d ',' -f 1)
    url=$(echo "$line" | cut -d ',' -f 2)
    url_esc=$(echo "$url" | sed -e 's/\//\\\//g')
    appNameLowercase=${appName,,}

    echo; echo 
    echo "###### Creating ${appName}"
    echo; echo 
    
    cp -r appMaster/ $temp_dir/$appNameLowercase/
    cp -f myApplist/$appNameLowercase.png $temp_dir/$appNameLowercase/icon.png

    cd $temp_dir/$appNameLowercase    

    sed -i "s/name__of__app__/${appName}/g" main.js 
    sed -i "s/https:\/\/example.com\//${url_esc}/g" main.js 

    sed -i "s/name__of__app__/${appName}/g" package.json
    sed -i "s/name__of__app_lc__/${appNameLowercase}/g" package.json

    npm install
    npm run dist

    cd dist
    cp *.AppImage $appimage_dir

    cd $temp_dir
    cd ..

done < "myApplist/applist.txt"

rm -r $temp_dir
