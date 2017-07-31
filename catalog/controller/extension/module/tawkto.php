<?php

/**
 * @package Tawk.to Integration
 * @author Tawk.to
 * @copyright (C) 2014- Tawk.to
 * @license GNU/GPLv3 http://www.gnu.org/licenses/gpl-3.0.html
 */

class ControllerExtensionModuleTawkto extends Controller {
    private static $displayed = false; //we include embed script only once even if more than one layout is displayed

    public function index() {

        if(self::$displayed) {
            return;
        }
        self::$displayed = true;

        $widget = $this->getWidget();
        if($widget === null) {
            echo '';
            return;
        }

        $data = array();
        $data['page_id'] = $widget['page_id'];
        $data['widget_id'] = $widget['widget_id'];
        $data['current_page'] = htmlspecialchars_decode('http://'.$_SERVER['HTTP_HOST'].$_SERVER['REQUEST_URI']);
        $data['cart_data'] = array();
        $data['customer'] = array();
        $data['orders'] = array();

        return $this->load->view('extension/module/tawkto', $data);
    }

    private function getWidget() {
        $this->load->model('setting/setting');

        $storeId = $this->config->get('config_store_id');
        $settings = $this->model_setting_setting->getSetting('tawkto', $storeId);
        $languageId = $this->config->get('config_language_id');
        $layoutId = $this->getLayoutId();

        $widget = null;
        if(!isset($settings['tawkto_widget'])) {
            return null;
        }

        $visibility = false;
        if (isset($settings['tawkto_visibility'])) {
            $visibility = $settings['tawkto_visibility'];
        }
        $settings = $settings['tawkto_widget'];

        if(isset($settings['widget_config_'.$storeId])) {
            $widget = $settings['widget_config_'.$storeId];
        }

        if(isset($settings['widget_config_'.$storeId.'_'.$languageId])) {
            $widget = $settings['widget_config_'.$storeId.'_'.$languageId];
        }

        if(isset($settings['widget_config_'.$storeId.'_'.$languageId.'_'.$layoutId])) {
            $widget = $settings['widget_config_'.$storeId.'_'.$languageId.'_'.$layoutId];
        }

        // get visibility options
        if ($visibility) {
            $visibility = json_decode($visibility);

            // prepare visibility
            $request_uri = trim($_SERVER["REQUEST_URI"]);
            if (stripos($request_uri, '/')===0) {
                $request_uri = substr($request_uri, 1);
            }
            $current_page = $this->config->get('config_url').$request_uri;
            
            if (false==$visibility->always_display) {

                // custom pages
                $show_pages = json_decode($visibility->show_oncustom);
                $show = false;

                $current_page = (string) $current_page;
                foreach ($show_pages as $slug) {
                    $slug = trim($slug);
                    if (empty($slug)) {
                        continue;
                    }

                    // use this when testing on a Linux/Win
                    // $slug = (string) htmlspecialchars($slug); // we need to add htmlspecialchars due to slashes added when saving to database
                    $slug = (string) urldecode($slug); // we need to add htmlspecialchars due to slashes added when saving to database
                    $slug = str_ireplace($this->config->get('config_url'), '', $slug);

                    // use this when testing on a Mac
                    // $slug = (string) urldecode($slug); // we need to add htmlspecialchars due to slashes added when saving to database

                    $slug = addslashes($slug);
                    
                    // $slug = urlencode($slug);
                    if (stripos($current_page, $slug)!==false || trim($slug)==trim($current_page)) {
                        $show = true;
                        break;
                    }
                }

                // category page
                if (isset($this->request->get['route']) && stripos($this->request->get['route'], 'category')!==false) {
                    if (false!=$visibility->show_oncategory) {
                        $show = true;
                    }
                }

                // home
                $is_home = false;
                if (!isset($this->request->get['route']) 
                    || (isset($this->request->get['route']) && $this->request->get['route'] == 'common/home')) {
                    $is_home = true;
                }
                
                if ($is_home) {
                    if (false!=$visibility->show_onfrontpage) {
                        $show = true;
                    }                
                }
                

                if (!$show) {
                    return;
                }

            } else {
                $hide_pages = json_decode($visibility->hide_oncustom);
                $show = true;
                
                // $current_page = urlencode($current_page);
                $current_page = (string) $current_page;
                foreach ($hide_pages as $slug) {

                    $slug = trim($slug);
                    if (empty($slug)) {
                        continue;
                    }

                    // use this when testing on a Linux/Win
                    // $slug = (string) htmlspecialchars($slug); // we need to add htmlspecialchars due to slashes added when saving to database
                    $slug = (string) urldecode($slug); // we need to add htmlspecialchars due to slashes added when saving to database
                    $slug = str_ireplace($this->config->get('config_url'), '', $slug);

                    // use this when testing on a Mac
                    // $slug = (string) urldecode($slug); // we need to add htmlspecialchars due to slashes added when saving to database

                    $slug = addslashes($slug);

                    // $slug = urlencode($slug);
                    if (stripos($current_page, $slug)!==false || trim($slug)==trim($current_page)) {
                        $show = false;
                        break;
                    }
                }

                if (!$show) {
                    return;
                }
            }
        }

        return $widget;
    }

    private function getLayoutId() {
        if (isset($this->request->get['route'])) {
            $route = $this->request->get['route'];
        } else {
            $route = 'common/home';
        }

        $this->load->model('design/layout');

        return $this->model_design_layout->getLayout($route);
    }
}
