<?php
/**
 * @package tawk.to Integration
 * @author tawk.to
 * @copyright (C) 2021 tawk.to
 * @license GNU/GPLv3 http://www.gnu.org/licenses/gpl-3.0.html
 */

define('PATTERN_MATCHING_UPDATE_VERSION', '1.5.0');

require_once dirname(__FILE__) . '/tawkto/vendor/autoload.php';

use Tawk\Modules\UrlPatternMatcher;

class ControllerExtensionModuleTawkto extends Controller {
    private static $displayed = false; //we include embed script only once even if more than one layout is displayed

    public function index() {
        if(self::$displayed) {
            return;
        }
        self::$displayed = true;

        $this->load->model('setting/setting');

        // get current plugin version in db
        $tawk_settings = $this->model_setting_setting->getSetting('tawkto'); // this gets the default store settings since that's where the version is stored.
        $plugin_version_in_db = '';
        if (isset($tawk_settings['tawkto_version'])) {
            $plugin_version_in_db = $tawk_settings['tawkto_version'];
        }

        $widget = $this->getWidget($plugin_version_in_db);
        $settings = json_decode($this->getVisibilitySettings());

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
        $data['can_monitor_customer_cart'] = false;
        $data['enable_visitor_recognition'] = true; // default

        if (!is_null($this->customer->getId())) {
            $data['customer'] = $this->customer;
        }

        if (!is_null($settings)) {
            if (!is_null($settings->monitor_customer_cart)) {
                $data['can_monitor_customer_cart'] = $settings->monitor_customer_cart;
            }

            if (!is_null($settings->enable_visitor_recognition)) {
                $data['enable_visitor_recognition'] = $settings->enable_visitor_recognition;
            }
        }

        return $this->load->view('extension/module/tawkto', $data);
    }

    private function getWidget($plugin_version_in_db) {
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

                if ($this->matchPatterns($current_page, $show_pages, $plugin_version_in_db)) {
                    $show = true;
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
                $current_page = (string) $current_page;

                if ($this->matchPatterns($current_page, $hide_pages, $plugin_version_in_db)) {
                    $show = false;
                }

                if (!$show) {
                    return;
                }
            }
        }

        return $widget;
    }

    private function getVisibilitySettings() {
        $storeId = $this->config->get('config_store_id');
        $settings = $this->model_setting_setting->getSetting('tawkto', $storeId);
        if (!isset($settings['tawkto_visibility'])) {
            return null;
        }

        return $settings['tawkto_visibility'];
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

    private function matchPatterns($current_page, $pages, $plugin_version) {
        if (version_compare($plugin_version, PATTERN_MATCHING_UPDATE_VERSION) >= 0) {
            return UrlPatternMatcher::match($current_page, $pages);
        }

        // handle backwards compatibility
        foreach ($pages as $slug) {
            $slug = trim($slug);
            if (empty($slug)) {
                continue;
            }

            $slug = (string) urldecode($slug); // we need to add htmlspecialchars due to slashes added when saving to database
            $slug = str_ireplace($this->config->get('config_url'), '', $slug);
            $slug = addslashes($slug);

            if (stripos($current_page, $slug)!==false || trim($slug)==trim($current_page)) {
                return true;
            }
        }

        return false;
    }
}
