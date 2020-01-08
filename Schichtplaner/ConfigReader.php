<?php

namespace Schichtplaner;

class ConfigReader {

    public static function getConfigOption($key) {
        if (!is_array($key)) {
            $key = explode('/', $key);
        }

        $value = SCHICHTPLANER;
        foreach ($key as $k) {
            if (!isset($value[$k])) return "";
            $value = $value[$k];
        }
        return $value;
    }

}
