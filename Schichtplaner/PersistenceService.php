<?php

namespace Schichtplaner;

use \dbConn;

class PersistenceService {

    /**
     * Gets all workers containing name and email.
     *
     * @param array Workers of all plans.
     */
    public static function getAllWorkers() {
        $arr = [];
        foreach (dbConn::query("SELECT DISTINCT w.name, w.email, w.plan  FROM `schichtplaner_worker` as w
                                INNER JOIN schichtplaner_plan AS p ON w.plan = p.name
                                WHERE p.deleted = 0
                                ORDER BY name, email ASC") as $r) {
            $arr[] = $r;
        }
        return $arr;
    }

}

?>