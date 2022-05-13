#!/bin/sh

release_version=$(jq -r '.version' ./composer.json);

echo "Creating temporary upload directory"
rm -rf ./upload
mkdir ./upload
mkdir -p ./upload/admin/controller/extension/module/tawkto
mkdir -p ./upload/catalog/controller/extension/module/tawkto

echo "Copying files to upload directory"
cp -r admin ./upload/
cp -r catalog ./upload/
cp -r ./vendor ./upload/admin/controller/extension/module/tawkto
cp -r ./vendor ./upload/catalog/controller/extension/module/tawkto
cp -r ./upgrades ./upload/admin/controller/extension/module/tawkto

echo "Creating opencart 2 zip files"
zip -9 -rq tawk-oc2-$release_version.ocmod.zip upload README.md
zip -9 -rq tawk-oc2-$release_version.zip admin catalog README.md

echo "Cleaning up"
rm -rf ./upload

echo "Done!"
