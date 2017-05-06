<?php

namespace Schichtplaner;

use \dbConn;

/**
 * Service class for data exchange with database.
 */
class PersistenceService {

    /**
     * Gets all workers containing name and email.
     *
     * @param array Workers of all plans.
     */
    public static function getAllWorkers() {
        $arr = [];
        foreach (dbConn::query("SELECT DISTINCT w.name, w.email, w.plan  FROM :prefix:worker as w
                                INNER JOIN :prefix:plan AS p ON w.plan = p.name
                                WHERE p.deleted = 0
                                ORDER BY name, email ASC") as $r) {
            $arr[] = $r;
        }
        return $arr;
    }

    /**
     * Loads count of required workers and already saved workers grouped by uid.
     *
     * @param string $plan name of the plan.
     *
     * @return array Array with all shifts containing required count and saved workers.
     */
    public static function getShiftsWithWorkers($plan) {
        $shifts = [];
        foreach (dbConn::query("SELECT 
                                    shift.shiftId,
                                    prod_shift.production,
                                    worker.name,
                                    worker.email,
                                    worker.isFixed,
                                    worker.position,
                                    prod_shift.required,
                                    shift.fromDate,
                                    shift.toDate
                                FROM :prefix:production_shift AS prod_shift
                                LEFT JOIN :prefix:shift AS shift
                                    ON shift.shiftId = prod_shift.shift 
                                    AND shift.plan = prod_shift.plan
                                LEFT JOIN :prefix:worker AS worker
                                    ON worker.production = prod_shift.production 
                                    AND worker.shift = shift.shiftId 
                                    AND worker.plan = prod_shift.plan
                                WHERE shift.plan = :0
                                ORDER BY production, shiftId, position ASC", $plan) as $entry) {
            $uid = makeUid($plan, $entry['production'], $entry['fromDate'], $entry['toDate']);
            if (!array_key_exists($uid, $shifts)) {
                $shifts[$uid] = [
                    'required'  => $entry['required'],
                    'shiftId'   => $entry['shiftId'],
                    'workers'   => []
                ];
            }
            if ($entry['name'] != null) {
                $shifts[$uid]['workers'][] = [
                    'name'      => $entry['name'],
                    'hasEmail'  => strlen($entry['email']) > 0,
                    'isFixed'   => (boolean) $entry['isFixed'] == true
                ];
            }
        }

        $arr = [];
        foreach ($shifts as $key => $data) {
            $arr[] = [
                'uid'       => $key,
                'required'  => $data['required'],
                'shiftId'   => $data['shiftId'],
                'workers'   => $data['workers']
            ];
        }

        return $arr;
    }

}

?>