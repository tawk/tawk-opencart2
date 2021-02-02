#!/bin/sh

if [ -z "$1" ]
    then
        echo "Release version wasn't specified";
        return;
fi

release_version=$1;

echo "Creating temporary upload directory"
rm -rf ./upload
mkdir ./upload

echo "Copying files to upload directory"
cp -r admin ./upload/
cp -r catalog ./upload/

echo "Creating opencart 3 zip files"
zip -9 -rq tawk-oc2-$release_version.ocmod.zip upload README.md
zip -9 -rq tawk-oc2-$release_version.zip admin catalog README.md

echo "Cleaning up"
rm -rf ./upload

echo "Done!"
