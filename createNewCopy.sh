#!/bin/bash


vers="0.0.1"

echo "Create new copy of viteyss-site- ... ver: $vers"


# $1 - default
# $2 - query
function mkQuery(){
    #echo "mkQuery"
    defRes=$1
    if [[ -n $1 ]]; then
        read -p "$2 [$1] : " "res"
    else
        read -p "$2 : " "res"
    fi

    if [[ -n $res ]]; then
        #echo "not empty"
        a=1
    else
        res=$defRes
    fi

    #echo "$tRet"
    #return "$tRet"
}

# $1 - pathToCount items in
function countFilesIn(){
    res=`ls "$1" | wc | awk '{print $1}'`
}



countFilesIn "$PWD"
if (( $res == 0 )); then
    #echo "[OK] directory empyty"
    res=''
else
    echo "Chk ... Files / directories in current path .... in: $res"
    echo "[E] You have files / directories in current path not good"
    exit 2
fi

## chk not nice if git is installed
res=`git --version`
exitRes=$?


pwdProj=$PWD
basenameProj=`basename $pwdProj`
pName=`basename $PWD`
mkQuery "$pName" "Set project / site name"
pName=$res
pNameNovy="${pName//viteyss-site-/}"

mkQuery "" "Description"
pDesc=$res

mkQuery "0.0.1" "Version"
pVer=$res

echo "Project / site name [$pName] use in code as [$pNameNovy]"
echo -e "desc: \n$pDesc\n\nVer: $pVer"


mkQuery "y" "Write it to files ...[y/n] "
echo "write:$res"
if [[ $res != 'y' ]];then
    echo "not Yes exit 3"
    exit 3
fi

echo "Installing copy ..."
echo "- pwd:$PWD"
echo "- will clone vanilla viteyss-site-hello-world ..."

git clone "https://github.com/yOyOeK1/viteyss-site-hello-world.git"
cd viteyss-site-hello-world

sold='"name": "viteyss-site-hello-world",'
snew='"name": "viteyss-site-'"$pNameNovy"'",'
sed -i "s/${sold}/${snew}/g" ./package.json

sold='"version": "0.0.1",'
snew='"version": "'"$pVer"'",'
sed -i "s/${sold}/${snew}/g" ./package.json

sold='description": ""'
snew='"description": "'"$pDesc"'"'
sed -i "s/${sold}/${snew}/g" ./package.json

echo "- ./package.json done ..."


sold='"oName": "s_vysHelloWolrdPage",'
snew='"oName": "s_vys'"$pNameNovy"'Page",'
sed -i "s/${sold}/${snew}/g" ./site.json

sold='"dir": "viteyss-site-hello-world",'
snew='"dir": "'"$basenameProj"'",'
sed -i "s/${sold}/${snew}/g" ./site.json

sold='"c_vys_hello_world_Page'
snew='"c_vys_'"$pNameNovy"'_Page'
sed -i "s/${sold}/${snew}/g" ./site.json

sold='"ver": "0.0.1",'
snew='"ver": "'"$pVer"'",'
sed -i "s/${sold}/${snew}/g" ./site.json

sold='"desc": "Test of viteyss-site- plugin system Hello World! Have template creator.",'
snew='"desc": "'"$pDesc"'",'
sed -i "s/${sold}/${snew}/g" ./site.json

echo "- ./site.json done ..."


sold='class s_vysHelloWolrdPage{'
snew='class s_vys'"$pNameNovy"'Page{'
sed -i "s/${sold}/${snew}/g" ./c_vys_hello_world_Page.js

sold='return `vys Hello World`;'
snew='return `vys '"$pNameNovy"'`;'
sed -i "s/${sold}/${snew}/g" ./c_vys_hello_world_Page.js

sold='export { s_vysHelloWolrdPage };'
snew='export { s_vys'"$pNameNovy"'Page };'
sed -i "s/${sold}/${snew}/g" ./c_vys_hello_world_Page.js

echo "- ./c_vys_hello_world_Page.js done ..."

mv -v ./c_vys_hello_world_Page.js './c_vys_'"$pNameNovy"'_Page.js'


sold='hello from viteyss-site-hello-world'
snew='hello from viteyss-site-'"$pNameNovy"
sed -i "s/${sold}/${snew}/g" ./index.js

echo "./index.js done ..."



echo "moving it ...."
cd ..
mv ./viteyss-site-hello-world/* ./
rm -rf ./viteyss-site-hello-world
rm ./README.md
rm ./createNewCopy.sh

echo "DONE ver: $ver"
tree ./
