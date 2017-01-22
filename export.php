<?php

require("config.php");
require("functions.php");

$colors = array(
    "ffcb99",  
    "ccffff",
    "cbffcc",
    "ffcbf8",
    "fffecb"
);
$specialColors = array(
    "missing"   => "d27d7d"  
);
$bgcolorIndex = 0;

// reference the Dompdf namespace
use Dompdf\Dompdf;

if(!isset($_GET['plan']) || dbConn::querySingle("SELECT COUNT(*) FROM :prefix:plan WHERE name = :0", urldecode($_GET['plan'])) < 1)
    die("Error: Invalid plan");
if(!isset($_GET['type']))
    $_GET['type'] = "pdf";
    
$plan = dbConn::querySingle("SELECT name FROM :prefix:plan WHERE name = :0", urldecode($_GET['plan']));
$type = strtolower($_GET['type']);

/*
 * PDF export
 */
 
if($type == "pdf")
{    
    $shifts = groupShifts($plan);   // array containing all data of the plan, grouped by productions and shifts
    //echo "<pre>".json_encode($shifts, JSON_PRETTY_PRINT)."</pre>";

    $tabContent = new template("pdf/plan.content");
    $tabContent->insert("active", "");
    $tabContent->insert("id", seoUrl($plan));
    $tabContent->insert("name", $plan);
    $tabContent->insert("hidden", "hidden");
    $first = false;
    $colSum = 0;
    
    
    foreach($shifts as $index => $values)
    {
    
        $planTpl = new template("pdf/plan.table");
        $tblCount = count($values['productions']);
        $colSize = 12;
        
        if($colSum + $colSize > 12)
        {
            $colSum = $colSize;
            $planTpl->insert("linebreak", "<div style=\"clear:both;\"></div><p style=\"page-break-before: always\"> ");
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
            $pr = new template("pdf/production");
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
            $t = new template("pdf/shift");
            $t->insert("fromToDate", str_replace(" ", "<br>", substr(str_replace(":00-", " - ", $sh), 0, 13)));

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

                $prodShift = new template("pdf/production_shift");
                $prodShift->insert("shiftId", $shiftId);
                $prodShift->insert("disabled", $has ? "" : "shift-disabled");
                $prodShift->insert("unique", seoUrl("$plan-$prod-" . substr(str_replace(":00-", " - ", $sh), 0, 13)));

                if($has)
                {
                    $workerCount = 0;
                    
                    // fill required number of workers, name
                    $prodShift->insert("name", $prod);

                    // get workers of one shift in one production
                    foreach(dbConn::query("SELECT * FROM :prefix:worker WHERE production = :0 AND shift = :1", 
                        $prod, $shiftId) as $r)
                    {
                        $worker = new template("pdf/worker");
                        $worker->insert("name", $r['name']);
                        $worker->insert("email", $r['email']);
                        $worker->insert("bgcolor", $colors[$bgcolorIndex]);
                        $worker->insert("fixed", $r['isFixed'] == 1 ? '<img src="' . BASEDIR . '/template/pdf/check.png" style="width:12px;">' : "");
                        $prodShift->insert("workers", $worker->getOutput());
                        $workerCount++;
                    }
                    
                    // insert placeholder for missing workers
                    for($i = 0; $i < $required - $workerCount; $i++) {
                        $worker = new template("pdf/worker");
                        $worker->insert("bgcolor", $specialColors['missing']);
                        $worker->insert("name", "&nbsp;");
                        $prodShift->insert("workers", $worker->getOutput());
                    }
                }

                $t->insert("shift_productions", $prodShift->getOutput());
            }

            $bgcolorIndex = array_search($colors[$bgcolorIndex], $colors) >= count($colors) - 1 ? 0 : $bgcolorIndex + 1; 
            $planTpl->insert("shifts", $t->getOutput());
        }
        
        if($index < count($shifts) - 1)
            $planTpl->insert("pagebreak", "<p style=\"page-break-before: always\"></p>");
            
        $bgcolorIndex = 0;
        $tabContent->insert("desktop", $planTpl);
    }
   
    $html = new template("pdf/container"); 
    $html->insert("content", $tabContent);
    $html->insert("name", $plan);
    $html->insert("date", (new DateTime())->format("d.m.y H:i"));
    $html->removeVariables();    
    
   // die($html->getOutput());
    
    $dompdf = new Dompdf();
    $dompdf->loadHtml($html->getOutput());
    $dompdf->setPaper('A4', 'landscape');
    $dompdf->render();
    $pdf = $dompdf->output();
    $dompdf->stream($plan);
    
}


?>