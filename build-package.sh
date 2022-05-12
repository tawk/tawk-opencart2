#!/bin/sh

release_version=$(jq -r '.version' ./composer.json);

echo "Creating temporary upload directory"
rm -rf ./upload
mkdir ./upload
mkdir ./upload/tawkto

echo "Copying files to upload directory"
cp -r admin ./upload/
cp -r catalog ./upload/
cp -r ./vendor ./upload/tawkto
cp -r ./upgrades ./upload/tawkto

echo "Creating opencart 2 zip files"
zip -9 -rq tawk-oc2-$release_version.ocmod.zip upload README.md
zip -9 -rq tawk-oc2-$release_version.zip admin catalog README.md

echo "Cleaning up"
rm -rf ./upload

echo "Done!"
