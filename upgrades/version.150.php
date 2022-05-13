<?php

if (!class_exists('TawkToUpgradeBase')) {
    require_once dirname(__FILE__) . '/base.php';
}

if (!class_exists('\Tawk\Helpers\PathHelper')) {
    require_once dirname(__FILE__) . '/../vendor/autoload.php';
}

use Tawk\Helpers\PathHelper;

class TawkToUpgradeVersion150 extends TawkToUpgradeBase {
    const VERSION = '1.5.0';

    public static function upgrade($model_setting, $model_store) {
        $store_ids = self::get_store_ids($model_store);
        foreach ($store_ids as $store_id) {
            $store_settings = $model_setting->getSetting('tawkto', $store_id);

            if (!isset($store_settings['tawkto_visibility'])) {
                continue;
            }

            $visibility = json_decode($store_settings['tawkto_visibility'], true);
            if (!empty($visibility['hide_oncustom'])) {
                $visibility['hide_oncustom'] = self::process_patterns(json_decode($visibility['hide_oncustom']));
            }

            if (!empty($visibility['show_oncustom'])) {
                $visibility['show_oncustom'] = self::process_patterns(json_decode($visibility['show_oncustom']));
            }

            $store_settings['tawkto_visibility'] = json_encode($visibility);

            $model_setting->editSetting('tawkto', $store_settings, $store_id);
        }
    }

    protected static function process_patterns($pattern_list) {
        $wildcard = PathHelper::get_wildcard();

        if (self::check_pattern_list_has_wildcard($pattern_list, $wildcard)) {
            return json_encode($pattern_list);
        }

        $new_pattern_list = [];
        $added_patterns = [];

        foreach ($pattern_list as $pattern) {
            if (empty($pattern)) {
                continue;
            }

            $pattern = ltrim($pattern, PHP_EOL);
            $pattern = trim($pattern);

            if (strpos($pattern, 'http://') !== 0 &&
                strpos($pattern, 'https://') !== 0 &&
                strpos($pattern, '/') !== 0
                ) {
                // Check if the first part of the string is a host.
                // If not, add a leading / so that the pattern
                // matcher treats is as a path.
                $firstPatternChunk = explode('/', $pattern)[0];
                if (self::check_valid_host($firstPatternChunk) === false) {
                    $pattern = '/' . $pattern;
                }
            }

            $new_pattern_list[] = $pattern;
            $newPattern = $pattern . '/' . $wildcard;
            if (in_array($newPattern, $pattern_list, true)) {
                continue;
            }

            if (true === isset($added_patterns[$newPattern])) {
                continue;
            }

            $new_pattern_list[] = $newPattern;
            $added_patterns[$newPattern] = true;
        }

        // EOL for display purposes
        return json_encode($new_pattern_list);
    }

    protected static function check_pattern_list_has_wildcard($patternList, $wildcard) {
        foreach ($patternList as $pattern) {
            if (strpos($pattern, $wildcard) > -1) {
                return true;
            }
        }

        return false;
    }

    protected static function check_valid_host($host) {
        // contains port
        if (strpos($host, ':') < 0) {
            return true;
        }

        // is localhost
        if (strpos($host, 'localhost') === 0) {
            return true;
        }

        // gotten from https://forums.digitalpoint.com/threads/what-will-be-preg_match-for-domain-names.1953314/#post-15036873
        // but updated the ending regex part to include numbers so it also matches IPs.
        $host_check_regex = '/^[a-zA-Z0-9]*((-|\.)?[a-zA-Z0-9])*\.([a-zA-Z0-9]{1,4})$/';

        return preg_match($host_check_regex, $host) > 0;
    }

    protected static function get_store_ids($model_store) {
        $retrieved_stores = $model_store->getStores();
        $stores = array(0);

        foreach ($retrieved_stores as $store) {
            array_push($stores, $store['store_id']);
        };

        return $stores;
    }
}
