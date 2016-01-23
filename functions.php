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
                            if(explode("-", str_replace(":", "", ($sh)))[0] >
                                explode("-", str_replace(":", "", ($a)))[0])
                            {
                                $newArr = Array();
                                for($i = 0; $i < $c; $i++)
                                    $newArr[] = $shifts[$collisionFreeIndex]['shifts'][$i];
                                $newArr[] = $a;
                                for($i = $c; $i < count($shifts[$collisionFreeIndex]['shifts']); $i++)
                                    $newArr[] = $shifts[$collisionFreeIndex]['shifts'][$i];

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
    
    // caluclate columns
    $maxProductionCount = 6;    // max productions per row
    $productionTimeSize = 2;    // adds this value to every time plan
    $counter = 0;
    $rowCount = 0;
    foreach($shifts as $key => $value)
    {
        if($counter + count($value['productions']) > $maxProductionCount)
        {
            $shifts[$key]['row'] = $rowCount;
            $rowCount++;
            $counter = count($value['productions']);
        }
        else
        {
            $counter += count($value['productions']);
        }
        
        if(!isset($shifts[$key]['row']))
            $shifts[$key]['row'] = $rowCount;
        $shifts[$key]['size'] = $counter;
    }
    
    //die("<pre>" . json_encode($shifts, JSON_PRETTY_PRINT) . "</pre>");
    
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

?>