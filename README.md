# tawk.to Live Chat

Free live chat widget for your site

This module is for Opencart 2.3.x

## Description

The tawk.to Live Chat app lets you monitor and chat with visitors on your OpenCart site. Be there when they need you with unlimited messaging, ticketing and your own Knowledge Base — all 100% FREE.

Don’t have an account yet? [Create one here!](https://tawk.to/?utm_source=opencart&utm_medium=link&utm_campaign=signup)

## Installation
This section describes how to install the plugin and get it working.

### Adding the module

#### Extension Installer
1. Download the plugin ending in `.ocmod.zip` from the OpenCart Marketplace.
2. Go to Extensions -> Extension Installer and upload the zip file.

#### Manual Installation
1. Download the plugin ending in `.zip` from the OpenCart Marketplace.
2. Extract the zip file and copy the files into your OpenCart folder. Then copy the Admin and Catalog folders and paste them into the opencart folder.

> If you aren’t using the English language for the OpenCart admin area, copy the language file into the correct language folder. If you are not using the default OpenCart theme, be sure to paste tawkto.tpl in the correct theme folder.

* admin/controller/extension/module/tawkto.php -> `<opencart_folder>`/admin/controller/extension/module/
* admin/language/english/extension/module/tawkto.php -> `<opencart_folder>`/admin/language/`<your_language>`/extension/module/
* admin/view/image/tawkto/ -> `<opencart_folder>`/admin/view/image/
* admin/view/template/extension/module/tawkto.tpl -> `<opencart_folder>`/admin/view/template/extension/module/
* catalog/controller/extension/module/tawkto.php -> `<opencart_folder>`/catalog/controller/extension/module/tawkto.php
* catalog/view/theme/default/template/extension/module/tawkto.tpl -> `<opencart_folder>`/catalog/view/theme/`<your_theme>`/template/extension/module/tawkto.tpl

### Widget Configuration
1. Go to the Modules section in the Extensions and install the tawk.to plugin there.
2. After installing, click the Edit button.
3. Log in to your tawk.to account.
4. Select the property the widget you want to place on your store and click the Use selected widget button.
5. The widget will now appear on your store.

## Frequently Asked Questions
Visit our [Help Center](https://help.tawk.to/) for answers to FAQs

## Changelog

### 1.3.0
* Added monitoring of cart item option to tawk.to module config page.

### 1.2.0
* Added visibility options to tawk.to module config page, to control the display of the chat widget in the frontend

### 1.1.0
* Updated tawk.to module config page to use new widget app

### 1.0.0
* Choose desired widget and it will be inserted in your site
