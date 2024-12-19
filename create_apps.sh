#/bin/bash/

temp_dir="${PWD}/temp/"
appimage_dir="${PWD}/myApps/"

wh=256
pad=10
wh_large=512

wxh=${wh}x${wh}
wh_inner=$((wh-pad*2))
wxh_inner=${wh_inner}x${wh_inner}


if [ ! -d "$temp_dir" ]; then
    mkdir -p "$temp_dir"
fi
if [ ! -d "$appimage_dir" ]; then
    mkdir -p "$appimage_dir"
fi


appName=$1
url=$2
url_esc=$(echo "$url" | sed -e 's/\//\\\//g')
appNameLowercase=${appName,,}


echo; echo 
echo "###### Creating ${appName}"
echo; echo 

cp -r appMaster/ $temp_dir/$appNameLowercase/
rm $temp_dir/$appNameLowercase/icon.png
curl "https://t2.gstatic.com/faviconV2?client=SOCIAL&type=FAVICON&fallback_opts=TYPE,SIZE,URL&url=$url&size=256" > $temp_dir/$appNameLowercase/icon.png
magick $temp_dir/$appNameLowercase/icon.png -resize $wxh_inner -background none -gravity center -extent $wxh $temp_dir/$appNameLowercase/icon.png

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

rm -r $temp_dir
