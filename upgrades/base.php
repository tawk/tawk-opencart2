<?php

abstract class TawkToUpgradeBase {
    const VERSION = null;

    public static function get_version() {
        if ( is_null( static::VERSION ) ) {
            throw new Exception( 'Subclass must have const VERSION' );
        }

        return static::VERSION;
    }

    public static function upgrade($model_setting, $model_store) {
        throw new Exception( 'Subclass must implement this!' );
    }
}
