<?php

require_once dirname(__FILE__) . '/version.150.php';

/**
* Upgrade manager for tawk.to plugin
*/
class TawkToUpgradeManager {
    public function __construct($dependencies, $options) {
        $this->model_setting = $dependencies['model_setting'];
        $this->model_store = $dependencies['model_store'];
        $this->upgrades = array(
            TawkToUpgradeVersion150::get_version() => TawkToUpgradeVersion150::class,
        );

        $this->version_var_name = $options['version_var_name'];
        $this->current_setting = $this->model_setting->getSetting('tawkto');
        $this->curr_ver = $options['version'];
        $this->prev_ver = '';

        if (isset($this->current_setting[$this->version_var_name])) {
            $this->prev_ver = $this->current_setting[$this->version_var_name];
        }
    }

    public function start() {
        if (!empty($this->prev_ver) && version_compare($this->prev_ver, $this->curr_ver) >= 0) {
            // do not do anything.
            return;
        }

        if (empty($this->prev_var)) {
            // initialize tawkto_version setting
            $this->current_setting[$this->version_var_name] = '';
            $this->model_setting->editSetting('tawkto', $this->current_setting);
        }

        // special case: we've never set the version before.
        // All plugins prior to the current version needs the upgrade.
        if (version_compare($this->prev_ver, $this->curr_ver) < 0) {
            // are there upgrade steps depending on how out-of-date?
            foreach ($this->upgrades as $upgrade_ver => $upgrade) {
                // only run upgrades if upgrade version is lower than
                // and equal to the current version.
                if (version_compare($upgrade_ver, $this->curr_ver) <= 0) {
                    $this->do_upgrade($upgrade_ver);
                }

                $this->model_setting->editSettingValue('tawkto', $this->version_var_name, $upgrade_ver);
            }
        }

    }

    protected function get_upgrade_class($version) {
        if (false === array_key_exists($version, $this->upgrades)) {
            return null;
        }

        return $this->upgrades[ $version ];
    }

    protected function do_upgrade($version) {
        $upgrade_class = $this->get_upgrade_class($version);

        if (true === is_null($upgrade_class)) {
            return;
        }

        $upgrade_class::upgrade($this->model_setting, $this->model_store);
    }
}
