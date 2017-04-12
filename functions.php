<?php

function groupShifts($plan)
{    
    // group shifts by same begin and end time
    $shifts = Array();
    foreach(dbConn::query("SELECT * FROM :prefix:production WHERE plan = :0 ORDER BY position", $plan) as $r)
    {
        // init with first production
        if(count($shifts) == 0)
        {
            $new = Array();
            $new['productions'] = Array();
            $new['productions'][] = $r['name'];
            $new['shifts'] = Array();
            
            foreach(dbConn::query(
                            "SELECT * FROM :prefix:production_shift AS ps
                             INNER JOIN :prefix:shift AS sh
                             ON ps.shift = sh.shiftId
                             WHERE production = :0 AND sh.plan = :1 
                             ORDER BY fromDate ASC, toDate DESC", $r['name'], $plan) as $s)
            {
                $new['shifts'][] = $s['fromDate'] . "-" . $s['toDate'];
            }
            $shifts[] = $new;
        }
        else
        {
            $c = 0;
            $arr = Array();
            $collision = false;
            $hasShifts = false;
            
            foreach(dbConn::query(
                            "SELECT * FROM :prefix:production_shift AS ps
                             INNER JOIN :prefix:shift AS sh
                             ON ps.shift = sh.shiftId
                             WHERE production = :0 AND sh.plan = :1
                             ORDER BY fromDate ASC, toDate DESC", $r['name'], $plan) as $s)
            {                
                $arr[] = $s['fromDate'] . "-" . $s['toDate'];
                $hasShifts = true;
            }
            
            if(!$hasShifts)
                continue;

            // detect collision
            $collisionFreeIndex = -1;
            foreach($shifts as $key1 => $entry)
            {
                $collision = false;
                foreach($entry['shifts'] as $key2 => $val)
                {
                    $from1 = explode("-", str_replace(":", "", ($val)))[0];
                    $to1 = explode("-", str_replace(":", "", ($val)))[1];

                    foreach($arr as $str)
                    {
                        if($val == $str)
                            continue;
                        $from2 = explode("-", str_replace(":", "", ($str)))[0];
                        $to2 = explode("-", str_replace(":", "", ($str)))[1];
                        if($from1 < $to2 && $from2 < $to1)
                        {
                            $collision = true;
                        }
                    }
                }

                if(!$collision)
                {
                    $collisionFreeIndex = $c;
                    break;
                }
                $c++;
            }

            if($collision)
            {
                $new = Array();
                $new['productions'] = Array();
                $new['productions'][] = $r['name'];
                $new['shifts'] = $arr;
                $shifts[] = $new;
            }
            else
            {
                $shifts[$collisionFreeIndex]['productions'][] = $r['name'];
                foreach($arr as $a)
                {
                    $c = 0;
                    if(!in_array($a, $shifts[$collisionFreeIndex]['shifts']))
                    {
                        foreach($shifts[$collisionFreeIndex]['shifts'] as $sh)
                        {
                            // prepend
                            if(explode("-", str_replace(":", "", ($sh)))[0] >
                                explode("-", str_replace(":", "", ($a)))[0])
                            {
                                $newArr = Array();
                                for($i = 0; $i < $c; $i++) {
                                    $newArr[] = $shifts[$collisionFreeIndex]['shifts'][$i];
                                }
                                $newArr[] = $a;
                                for($i = $c; $i < count($shifts[$collisionFreeIndex]['shifts']); $i++) {
                                    $newArr[] = $shifts[$collisionFreeIndex]['shifts'][$i];
                                }

                                $shifts[$collisionFreeIndex]['shifts'] = $newArr;
                                break;
                            }
                            // append
                            else 
                            {
                                $newArr = Array();
                                for($i = 0; $i < $c; $i++) {
                                    $newArr[] = $shifts[$collisionFreeIndex]['shifts'][$i];
                                }
                                for($i = $c; $i < count($shifts[$collisionFreeIndex]['shifts']); $i++) {
                                    $newArr[] = $shifts[$collisionFreeIndex]['shifts'][$i];
                                }
                                $newArr[] = $a;

                                $shifts[$collisionFreeIndex]['shifts'] = $newArr;
                                break;
                            }
                            
                            $c++;
                        }
                    }
                }
            }
        }
    }
    
    //echo("<pre>" . json_encode($shifts, JSON_PRETTY_PRINT) . "</pre>");
    
    return $shifts;
}

function getRowSize($arr, $rowIndex)
{
    $size = 0;
    foreach($arr as $key => $value)
    {
        if($value['row'] == $rowIndex)
            $size += $value['size'];
    }
    return $size;
}

function seoUrl($string) {    
    // Make alphanumeric (removes all other characters)
    $string = preg_replace("/[^a-zA-Z0-9_\s-]/", "", $string);
    
    // Clean up multiple dashes or whitespaces
    $string = preg_replace("/[\s-]+/", " ", $string);
    
    // Convert whitespaces and underscore to dash
    $string = preg_replace("/[\s_]/", "-", $string);
    return $string;
}

function isLoggedin() {
    if (!isset($_SESSION['user']) || !isset($_SESSION['userData']))
        return false;

    $userdb = dbConn::queryRow("SELECT * FROM :prefix:user WHERE name = :0", $_SESSION['user']);
    $logout = $userdb == null || $_SESSION['userData']['lastchange'] != $userdb['lastchange'];
    return isset($_SESSION['user']) && !$logout;
}

/**
 * Prints a json result object and stops the script.
 *
 * @param boolean $success Boolean whether operation was done successfully or failed.
 * @param string $message A message for user frontend.
 * @param array $additional {
 *      An associative array for any further key-value pairs.
 *
 *      @type string $key
 *      @type object $value
 *}
 */
function returnResult($success, $message, $additional = null) {
    $arr = [
        "success"   => (bool) $success
    ];

    if (strlen($message) > 0) {
        $arr['message'] = $message;
    }

    if ($additional != null && array_keys($additional) !== range(0, count($additional) - 1)) {
        foreach ($additional as $k => $v) {
            $arr[$k] = $v;
        }
    }
    
    header("content-type: application/json");
	echo json_encode($arr);
	die();
}

?>