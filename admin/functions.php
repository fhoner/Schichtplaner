<?php

function getHistory($limit)
{
    if(!isset($limit) || $limit == 0 || $limit == null || !is_numeric($limit))
        $limit = 9999999;
    $changes = new template("admin/lastchanges.container");
    
    
    foreach(dbConn::query("SELECT
                                action, 
                                nameBefore, 
                                nameAfter, 
                                emailBefore, 
                                emailAfter, 
                                isFixedBefore,
                                isFixedAfter,
                                production, 
                                fromDate,
                                toDate,
                                :prefix:plan.name AS plan, 
                                :prefix:worker_history.created
                            FROM :prefix:worker_history 
                            INNER JOIN :prefix:shift ON :prefix:shift.shiftId = :prefix:worker_history.shift
                            INNER JOIN :prefix:plan ON :prefix:shift.plan = :prefix:plan.name
                            ORDER BY :prefix:worker_history.created DESC LIMIT 0, " . $limit) as $r)
    {
        $change = new template("admin/lastchanges.entry");
        switch($r['action'])
        {
            case "insert":
                $change->insert("action", "<span style=\"color:green;\"><small>
                                            <i class=\"fa fa-plus-square\"></i>
                                           </small></span>&nbsp;&nbsp;Hinzugefügt");
                break;
            case "update":
                $change->insert("action", "<span style=\"color:orange;\"><small>
                                            <i class=\"fa fa-minus-square\"></i>
                                           </small></span>&nbsp;&nbsp;Bearbeitet");
                break;
            case "delete":
                $change->insert("action", "<span style=\"color:red;\">
                                            <small><i class=\"fa fa-trash\"></i>
                                           </small></span>&nbsp;&nbsp;Gelöscht");
                break;
            default:
                $change->insert("action", "Unbekannt");
                break;
        }
        $change->insert("shift", "<small>$r[plan], $r[production]</small><br />" .
                                substr($r['fromDate'], 0, 5) . " - " . substr($r['toDate'], 0, 5));
        if($r['nameBefore'] == $r['nameAfter']
                && $r['isFixedBefore'] == $r['isFixedAfter'])
            $change->insert("user", $r['nameAfter']);
        else
            $change->insert("user", 
                ($r['action'] == "update" || $r['action'] == "delete" ? 
                "<small>" .
                    ($r['isFixedBefore'] ? "<span class=\"glyphicon glyphicon-question-sign worker-not-fixed\" aria-hidden=\"true\"></span> " :
                                          "<span class=\"glyphicon glyphicon-ok-sign worker-fixed\" aria-hidden=\"true\"></span> ") : "") .
                    "<span style=\"text-decoration:line-through;\">$r[nameBefore]</span>
                </small>" .
                ($r['action'] == "update" ? "<br>" : "") .
                "<strong>" .
                    ($r['action'] == "update" || $r['action'] == "insert" ? 
                    ($r['isFixedAfter'] ? "<span class=\"glyphicon glyphicon-question-sign worker-not-fixed\" aria-hidden=\"true\"></span> " :
                                           "<span class=\"glyphicon glyphicon-ok-sign worker-fixed\" aria-hidden=\"true\"></span> ") : "") .                
                    "$r[nameAfter]
                </strong>");
        if($r['emailBefore'] == $r['emailAfter'])
            $change->insert("email", $r['emailAfter']);
        else
            $change->insert("email", "<small><span style=\"text-decoration:line-through;\">$r[emailBefore]</span></small>
            <br /><strong>$r[emailAfter]</strong>");

        $change->insert("date", (new DateTime($r['created']))->format("d.m.y H:i"));
        $changes->insert("content", $change->getOutput());
    }
    
    
    $changes->removeVariables();
    return $changes->getOutput();
}
?>