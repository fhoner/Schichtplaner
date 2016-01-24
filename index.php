<?php

require("config.php");
require("functions.php");

$count = 0;
$first = true;
$tpl = new template("index");

foreach(dbConn::query("SELECT *, IF(editable > CURRENT_TIMESTAMP, 1, 0) AS editable FROM :prefix:plan 
                       WHERE deleted = 0 AND public > CURRENT_TIMESTAMP ORDER BY created DESC") as $pl)
{
    $plan = $pl['name'];    
    $isReadonly = !$pl['editable'];
    $shifts = groupShifts($plan);

    $tab = new template("plan.tab");
    $tab->insert("active", $first ? "active" : "");
    $tab->insert("name", $plan);
    $tpl->insert("plansTab", $tab->getOutput());

    $tabContent = new template("plan.content");
    $tabContent->insert("active", $first ? "active" : "");
    $tabContent->insert("name", $plan);
    $tabContent->insert("hidden", $isReadonly ? "" : "hidden");

    $first = false;
    $colSum = 0;
    foreach($shifts as $index => $values)
    {
        $planTpl = new template("plan.table");
        $planTpl->insert("readonly", $isReadonly ?  "plan-readonly" : "");
        $tblCount = count($values['productions']);
        $colSize = round(12 / getRowSize($shifts, $values['row']) * $values['size']);
        
        if($colSum + $colSize > 12)
        {
            $colSum = $colSize;
            $planTpl->insert("linebreak", "<div style=\"clear:both;\"></div>");
            $planTpl->insert("tableCount", $colSize);
        }
        else
        {        
            if($colSum == 0)
                $colSum = $colSize;
            $colSum += $colSize;
            $planTpl->insert("tableCount", $colSize);
        }               

        foreach($values['productions'] as $prod)
        {
            $pr = new template("production");
            $pr->insert("name", $prod);
            $pr->insert("plan", $plan);
            $pr->insert("url", rawurlencode(URL . "/"));
            $pr->insert("organisation", rawurlencode(ORGANISATION));
            $pr->insert("webmaster", WEBMASTER);
            
            $master = dbConn::queryRow("SELECT masterName, masterEmail FROM :prefix:production
                                        WHERE plan = :0 AND name = :1", $plan, $prod);
            $pr->insert("masterName", $master['masterName']);
            $pr->insert("masterEmail", $master['masterEmail']);
            
            $planTpl->insert("productions", $pr->getOutput());
        }

        foreach($values['shifts'] as $sh)
        {            
            $t = new template("shift");
            $t->insert("fromToDate", substr(str_replace(":00-", " - ", $sh), 0, 13));

            $shiftId = dbConn::querySingle("SELECT shiftId FROM :prefix:shift WHERE 
                plan = :0 AND fromDate = :1 AND toDate = :2 ",
                                                $plan,
                                                explode("-", str_replace(":", "", ($sh)))[0],
                                                explode("-", str_replace(":", "", ($sh)))[1]);

            foreach($values['productions'] as $prod)
            {                
                // separate tables
                if(!in_array($prod, $values['productions']))
                    continue;

                $has = false;
                $required = 0;
                foreach(dbConn::query("SELECT * FROM :prefix:production_shift WHERE production = :0 AND shift = :1", 
                    $prod, $shiftId) as $r)
                {
                    $required = $r['required'];
                    $has = true;
                }

                $prodShift = new template("production_shift");
                $prodShift->insert("shiftId", $shiftId);
                $prodShift->insert("disabled", $has ? "" : "shift-disabled");

                if($has)
                {
                    // fill required number of workers, name
                    $prodShift->insert("required", $required);
                    $prodShift->insert("name", $prod);

                    // get workers of one shift in one production
                    foreach(dbConn::query("SELECT * FROM :prefix:worker WHERE production = :0 AND shift = :1", 
                        $prod, $shiftId) as $r)
                    {
                        $worker = new template("worker");
                        $worker->insert("name", $r['name']);
                        $worker->insert("email", $r['email']);
                        $prodShift->insert("workers", $worker->getOutput());
                    }
                }


                $t->insert("shift_productions", $prodShift->getOutput());
            }


            $planTpl->insert("shifts", $t->getOutput());
        }

        $tabContent->insert("content", $planTpl->getOutput());
    }

    $tpl->insert("plansContent", $tabContent->getOutput());
}


$tpl->removeVariables();
echo $tpl->getOutput();

?>