<?php

require("../config.php");
require("functions.php");

if(!isset($_POST['v']))
    $_POST['v'] = "dashboard";

switch($_POST['v'])
{
    case 'dashboard':
        $output = "";
        
        $plans = new template("admin/plans.container");
        foreach(dbConn::query("SELECT name FROM :prefix:plan WHERE deleted = 0 ORDER BY created DESC") as $r)
        {
            $plan = new template("admin/plans.entry");
            $plan->insert("plan", $r['name']);
            
            $plan->insert("shifts", dbConn::querySingle(
                "SELECT COUNT(*) 
                 FROM :prefix:shift
                 INNER JOIN :prefix:production_shift
                 ON :prefix:shift.shiftId = :prefix:production_shift.shift
                 WHERE :prefix:shift.plan = :0", $r['name']));
            
            $requiredWorkers = dbConn::querySingle(
                "SELECT SUM(required) 
                 FROM :prefix:shift
                 INNER JOIN :prefix:production_shift
                 ON :prefix:shift.shiftId = :prefix:production_shift.shift
                 WHERE :prefix:production_shift.plan = :0
                 GROUP BY :prefix:shift.plan", $r['name']);
            $plan->insert("requiredWorkers", $requiredWorkers);
            
            $missingWorkers = $requiredWorkers - dbConn::querySingle(
                "SELECT COUNT(*) 
                 FROM :prefix:shift
                 INNER JOIN :prefix:worker
                 ON :prefix:worker.shift = :prefix:shift.shiftId
                 WHERE plan = :0", $r['name']);
            $plan->insert("missingWorkers", $missingWorkers);
            
            $plans->insert("content", $plan->getOutput());
        }
        $plans->removeVariables();
        $output .= $plans->getOutput();        
        $output .= getHistory(5);        
        echo $output;
        break;
        
    case "plan":
        $plan = dbConn::queryRow("SELECT * FROM :prefix:plan WHERE name = :0 AND deleted = 0 ORDER BY created DESC", $_POST['p']);
        if($plan == null)
        {
            $err = new template("admin/danger");
            $err->insert("text", "Der angeforderte Plan konnte nicht gefunden werden.");
            die($err->getOutput());
        }
        $tpl = new template("admin/plan.edit");
        $tpl->insert("name", $plan['name']);
        $tpl->insert("public", (new DateTime($plan['public']))->format("d.m.Y"));
        $tpl->insert("editable", (new DateTime($plan['editable']))->format("d.m.Y"));
        
        $subscriber = Array();
        foreach(dbConn::query("SELECT email FROM :prefix:email_subscriber WHERE plan = :0 ORDER BY email ASC", $plan['name']) as $r)
            array_push($subscriber, $r['email']);
        for($i = 0; $i < count($subscriber); $i++)
            $tpl->insert("emailSubscribers", $i == count($subscriber) - 1 ? $subscriber[$i] : $subscriber[$i] . "\n");
                
        foreach(dbConn::query("SELECT DISTINCT name FROM :prefix:production WHERE plan = :0 ORDER BY position", $plan['name']) as $r)
        {
            $sh = new template("admin/plan.edit.shift");
            $sh->insert("name", $r['name']);
            $master = dbConn::queryRow("SELECT masterName, masterEmail FROM :prefix:production
                                        WHERE plan = :0 AND name = :1", $plan['name'], $r['name']);
            $sh->insert("masterName", $master['masterName']);
            $sh->insert("masterEmail", $master['masterEmail']);
            
            foreach(dbConn::query("SELECT * FROM :prefix:shift WHERE plan = :0", $plan['name']) as $s)
            {
                $prods = new template("admin/plan.edit.shift.productions");
                $prods->insert("name", $s['fromDate'] . " - " . $s['toDate']);
                $prods->insert("value", $s['shiftId']);
                $prods->insert("checked", dbConn::querySingle("SELECT COUNT(*) 
                                                                FROM :prefix:production_shift
                                                                INNER JOIN :prefix:production ON production = name
                                                                INNER JOIN :prefix:shift ON shift = shiftId
                                                                WHERE production = :0 AND shiftId = :1", $r['name'], $s['shiftId']) > 0 ?
                              "checked" : "");
                
                $required = dbConn::querySingle(
                    "SELECT required FROM :prefix:production_shift 
                     WHERE production = :0 AND shift = :1", $r['name'], $s['shiftId']);
                $prods->insert("workers", $required != "" ? $required  : "0");
                
                $sh->insert("shifts", $prods->getOutput());
            }
            
            $tpl->insert("shifts", $sh->getOutput());
        }
        
        foreach(dbConn::query("SELECT * FROM :prefix:shift WHERE plan = :0 ORDER BY fromDate ASC, toDate DESC", $plan['name']) as $r)
        {
            $sh = new template("admin/plan.edit.time");
            $sh->insert("id" ,$r['shiftId']);
            $sh->insert("from", $r['fromDate']);
            $sh->insert("to", $r['toDate']);
            $tpl->insert("times", $sh->getOutput());
        }
        
        
        $tpl->removeVariables();
        echo $tpl->getOutput();
        break;
        
    case "history":
        echo getHistory(0);
        break;
        
    case "newplan":
        $tpl = new template("admin/plan.create");
        echo $tpl->getOutput();
        break;
        
    default:
        echo "
        <div class='alert alert-danger' role='alert'>
          <span class='sr-only'>Fehler:</span>
          Funktion nicht implementiert
        </div>";
        break;
}


?>