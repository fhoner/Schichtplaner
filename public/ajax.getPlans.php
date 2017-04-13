<?php

require("../config.php");
require(BASEDIR . "functions.php");

function prodContainsShift($prod, $shift, $haystack) {
    foreach ($haystack as $db) {
        if ($db['production'] == $prod && $db['fromDate'] . "-" . $db['toDate'] == $shift) {
            return true;
        }
    }

    return false;
}

/**
 * Makes a uid string.
 *
 * @param string $plan Name of the plan.
 * @param string $production Name of the production.
 * @param string $fromDate begin date.
 * @param string $toDate end date.
 *
 * @return string Valid string ready for usage as css id.
 */
function makeUid($plan, $production, $fromDate, $toDate) {
    return seoUrl(
            $plan . "-" .
            $production . "-"
        ) .
        substr($fromDate, 0, 5) . "-" .
        substr($toDate, 0, 5);
}

/**
 * Loads count of required workers and already saved workers grouped by uid.
 *
 * @param string $plan name of the plan.
 *
 * @return array Array with all shifts containing required count and saved workers.
 */
function getDetailedShifts($plan) {
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

$plans = [];
foreach(dbConn::query("SELECT *, IF(editable > CURRENT_TIMESTAMP, 1, 0) AS editable FROM :prefix:plan 
                       WHERE deleted = 0 AND public > CURRENT_TIMESTAMP ORDER BY position ASC") as $pl) {

    $groups = groupShifts($pl['name']);   // array of the plan, merged by productions and shifts

    $shiftsDb = [];
    foreach(dbConn::query("SELECT 
                                ps.production, 
                                ps.shift, 
                                ps.required, 
                                s.fromDate, 
                                s.toDate, 
                                p.masterName, 
                                p.masterEmail, 
                                p.position 
                            FROM :prefix:production_shift AS ps
                            INNER JOIN :prefix:shift AS s
                                ON ps.shift = s.shiftId AND ps.plan = s.plan
                            INNER JOIN :prefix:production AS p
                                ON p.name = ps.production AND p.plan = ps.plan
                            WHERE ps.plan = :0
                            ORDER BY position ASC", $pl['name']) as $db)
                            $shiftsDb[] = $db;

    /*
     * To find disabled slots, the default grouped-json does not meet requirements.
     * Also send a object by which the frontend can disable cells. Cells may be disabled
     * if all time boxes match without overlapping each other.
     */
    $newGroups = [];
    $i = 0;
    foreach ($groups as $group) {
        
        $newArr = [];
        foreach ($group['productions'] as $production) {
            $prod = [];
            $prod['shifts'] = [];
            $prod['name'] = $production;
            foreach ($group['shifts'] as $shift) {
                if (prodContainsShift($production, $shift, $shiftsDb) && !in_array($shift, $prod['shifts']))
                    $prod['shifts'][] = $shift;
            }
            $newArr[] = $prod;
        }

        $newShifts = [];
        foreach ($group['shifts'] as $shift) {
            $temp = explode("-", $shift);
            $newShifts[] = [
                "from"  => substr($temp[0], 0, 5),
                "to"  => substr($temp[1], 0, 5)
            ];
        }
        $groups[$i]['shifts'] = $newShifts;

        // add master name and email
        $prod = [];
        foreach ($group['productions'] as $production) {   
            $masterName = "";
            $masterEmail = "";
            foreach ($shiftsDb as $db) {
                if ($db['production'] == $production) {
                    $masterName = $db['masterName'];
                    $masterEmail = $db['masterEmail'];
                    break;
                }
            }
            $prod[] = [
                'productionName'    => $production,
                'productionUid'     => seoUrl($production),
                'masterName'        => $masterName,
                'masterEmail'       => $masterEmail
            ];
        }
        $groups[$i]['productions'] = $prod;        

        $newGroups[] = $newArr;
        $i++;
    }

    $plans[] = [
        'name'          => $pl['name'],
        'uid'           => seoUrl($pl['name']),
        'urlencoded'    => urlencode($pl['name']),
        'readonly'      => !$pl['editable'],
        'groups'        => $groups,
        'shifts'        => getDetailedShifts($pl['name'])
    ];
}



header("content-type: application/json");
echo json_encode(array(
    "plans"   => $plans
));

?>