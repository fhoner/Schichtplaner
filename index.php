<?php

$start = microtime();
require("config.php");
require("functions.php");

$count = 0;
$first = true;
$tpl = new template("index");
$tpl->insert("organisation", ORGANISATION);

// iterate plans
foreach(dbConn::query("SELECT *, IF(editable > CURRENT_TIMESTAMP, 1, 0) AS editable FROM :prefix:plan 
                       WHERE deleted = 0 AND public > CURRENT_TIMESTAMP ORDER BY position ASC") as $pl)
{
    $plan = $pl['name'];    // plan name
    $isReadonly = !$pl['editable']; // plan is readonly
    $shifts = groupShifts($plan);   // array containing all data of the plan, grouped by productions and shifts
    //echo "<pre>".json_encode($shifts, JSON_PRETTY_PRINT)."</pre>";
    
    $tab = new template("plan.tab");
    $tab->insert("active", $first ? "active" : "");
    $tab->insert("id", seoUrl($plan));
    $tab->insert("name", $plan);
    $tpl->insert("plansTab", $tab->getOutput());

    $tabContent = new template("plan.content");
    $tabContent->insert("active", $first ? "active" : "");
    $tabContent->insert("id", seoUrl($plan));
    $tabContent->insert("name", $plan);
    $tabContent->insert("export", URL . "/export.php?plan=" . urlencode($plan));
    $tabContent->insert("hidden", $isReadonly ? "" : "hidden");

    $first = false;
    $colSum = 0;
    foreach($shifts as $index => $values)
    {
        /*
         * Create mobile device output, which means every production will
         * written into its own table.
         */
         
         foreach($values['productions'] as $p)
         {
            $mobile = new template("plan.table");
            $mobile->insert("readonly", $isReadonly ? "plan-readonly" : "");
            $mobile->insert("tableCount", "12");
            
            $pr = new template("production");
            $pr->insert("name", $p);
            $pr->insert("nameEscaped", rawurlencode($p));
            $pr->insert("plan", rawurlencode($plan));
            $pr->insert("url", rawurlencode(URL . "/"));
            $pr->insert("organisation", rawurlencode(ORGANISATION));
            $pr->insert("webmaster", WEBMASTER);
            
            $master = dbConn::queryRow("SELECT masterName, masterEmail FROM :prefix:production
                                        WHERE plan = :0 AND name = :1", $plan, $p);
            $pr->insert("masterName", $master['masterName']);
            $pr->insert("masterEmail", $master['masterEmail']);
            $mobile->insert("productions", $pr->getOutput());
            
            foreach($values['shifts'] as $sh)
            {
                $t = new template("shift");
                $t->insert("fromToDate", substr(str_replace(":00-", " - ", $sh), 0, 13));
                
                $shiftId = dbConn::querySingle("SELECT shiftId FROM :prefix:shift WHERE 
                    plan = :0 AND fromDate = :1 AND toDate = :2 ",
                                                    $plan,
                                                    explode("-", str_replace(":", "", ($sh)))[0],
                                                    explode("-", str_replace(":", "", ($sh)))[1]);
                                                    
                $has = false;
                $required = 0;
                $comment = "";
                foreach(dbConn::query("SELECT * FROM :prefix:production_shift WHERE production = :0 AND shift = :1", 
                    $p, $shiftId) as $r)
                {
                    $required = $r['required'];
                    $comment = $r['comment'];
                    $has = true;
                }
                
                if(!$has) {
                    continue;
                }

                $prodShift = new template("production_shift");
                $prodShift->insert("shiftId", $shiftId);
                $prodShift->insert("comment", $comment);
                $prodShift->insert("disabled", $has ? "" : "shift-disabled");
                $prodShift->insert("unique", seoUrl("$plan-$p-" . substr(str_replace(":00-", " - ", $sh), 0, 13)));

                if($has)
                {
                    // fill required number of workers, name
                    $prodShift->insert("required", $required);
                    $prodShift->insert("name", $p);

                    // get workers of one shift in one production
                    foreach(dbConn::query("SELECT * FROM :prefix:worker WHERE production = :0 AND shift = :1 ORDER BY name ASC", 
                        $p, $shiftId) as $r)
                    {
                        $worker = new template("worker");
                        $worker->insert("fixed", $r['isFixed'] ? "" : "not-fixed");
                        $worker->insert("name", $r['name']);
                        $worker->insert("email", $r['email']);
                        $prodShift->insert("workers", $worker->getOutput());
                    }
                }

                $t->insert("shift_productions", $prodShift->getOutput());
                $mobile->insert("shifts", $t->getOutput());
            }
                      
            
            $tabContent->insert("mobile", $mobile);
         }
        
        
        
        /*
         * Create desktop output, which means grouped productions will be placed
         * into single table.
         */
         
        $planTpl = new template("plan.table");
        $planTpl->insert("readonly", $isReadonly ?  "plan-readonly" : "");
        $colSize = count($values['productions']);
        $nextColSize = 0;
        if(count($shifts) > $index + 1) 
            $nextColSize = count($shifts[$index + 1]['productions']);
        if($colSize + $nextColSize > 6)
        {
            $colSum = 0;
            $planTpl->insert("linebreak", "<div style=\"clear:both;\"></div>");
            $planTpl->insert("tableCount", $colSize);
        }
        else
        {      
            $colSum = $colSize;
            $planTpl->insert("tableCount", $colSize);
        }        
        
        //echo "$plan $colSize $colSum<br>";       

        foreach($values['productions'] as $prod)
        {
            $pr = new template("production");
            $pr->insert("name", $prod);
            $pr->insert("nameEscaped", rawurlencode($prod));
            $pr->insert("plan", rawurlencode($plan));
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
                $prodShift = new template("production_shift");
                foreach(dbConn::query("SELECT * FROM :prefix:production_shift WHERE production = :0 AND shift = :1", 
                    $prod, $shiftId) as $r)
                {
                    $required = $r['required'];
                    $prodShift->insert("comment", $r['comment']);
                    $has = true;
                }

                $prodShift->insert("shiftId", $shiftId);
                $prodShift->insert("disabled", $has ? "" : "shift-disabled");
                $prodShift->insert("unique", seoUrl("$plan-$prod-" . substr(str_replace(":00-", " - ", $sh), 0, 13)));

                if($has)
                {
                    // fill required number of workers, name
                    $prodShift->insert("required", $required);
                    $prodShift->insert("name", $prod);

                    // get workers of one shift in one production
                    foreach(dbConn::query("SELECT * FROM :prefix:worker WHERE production = :0 AND shift = :1 ORDER BY name ASC", 
                        $prod, $shiftId) as $r)
                    {
                        $worker = new template("worker");
                        $worker->insert("name", $r['name']);
                        $worker->insert("email", $r['email']);
                        $worker->insert("fixed", $r['isFixed'] ? "" : "not-fixed");
                        $prodShift->insert("workers", $worker->getOutput());
                    }
                }

                $t->insert("shift_productions", $prodShift->getOutput());
            }

            $planTpl->insert("shifts", $t->getOutput());
        }

        $tabContent->insert("desktop", $planTpl->getOutput());
    }

    $tpl->insert("plansContent", $tabContent->getOutput());
}



// insert page request duration
$diff = microtime() - $start;
$diff = round($diff * 1000);
$tpl->insert("creationTime", $diff > 0 ? $diff : "unknown");

$tpl->removeVariables();
echo $tpl->getOutput();

?>