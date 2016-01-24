<?php

require("config.php");
require("functions.php");
require("transaction.php");

/*
    Sample of an incoming data array:

    Array
    (
        [plan] => 'Donnerstag'
        [data] => Array
            (
                 [deleted] => Array
                    (
                        [0] => Array
                            (
                                [name] => Corina Ott edited
                                [email] => cott@gmx.de
                            )

                    )
                [shiftId] => 3
                [production] => Grill
                [workers] => Array
                    (
                        [0] => Array
                            (
                                [name] => Felix Honer
                                [email] => privat@feix-honer.com
                                [action] => update
                                [uid] => Felix Honer\nprivat@felix-honer.com
                            )

                        [1] => Array
                            (
                                [name] => Wolfgang Bergler
                                [email] => w.bergler@web.de
                                [action] => create
                                [uid] => Wolfgang Bergler\nw.bergler@web.de
                            )

                    )

            )

    )
*/

$d = $_POST['data'];
$errors = array();

// validation checks
if(isset($d['workers']))
    foreach($d['workers'] as $worker)
    {
        $nameRegex = "/^[A-Z][-a-zA-Z]+$/";
        if(trim($worker['name']) == ""
            || preg_match($nameRegex, $worker['name']))
            $errors[] = "Der Name <strong>$worker[name]</strong> ist ungültig.";
        
        $temp = str_replace("ö", "oe", $worker['email']);
        $temp = str_replace("Ö", "Oe", $temp);
        $temp = str_replace("ä", "ae", $temp);
        $temp = str_replace("Ä", "Ae", $temp);
        $temp = str_replace("ü", "ue", $temp);
        $temp = str_replace("Ü", "Ue", $temp);
        
        if (!filter_var($temp, FILTER_VALIDATE_EMAIL)) 
            $errors[] = "Die E-Mail Adresse <strong>$worker[email]</strong> ist ungültig.";
    }

if(count($errors) > 0) 
{
    echo "<ul>";
    foreach($errors as $err)
        echo "<li>$err</li>";
    die();
}

if(dbConn::querySingle("SELECT COUNT(*) FROM :prefix:plan WHERE 
                            name = :0
                            public < CURRENT_TIMESTAMP OR 
                            editable < CURRENT_TIMESTAMP", $_POST['plan']) > 1)
{
    die("REFRESH");
}

try
{

    $t = new transaction();


    // delete removed workers from database
    if(isset($d['deleted']))
        foreach($d['deleted'] as $key => $val)
        {
            $t->addStatement("DELETE FROM :prefix:worker WHERE production = :0 
                                                                AND shift = :1
                                                                AND name = :2
                                                                AND email = :3", 
                                                            $d['production'], 
                                                            $d['shiftId'],
                                                            $val['name'],
                                                            $val['email']
                            );
        }

    // update existing or insert the added workers
    if(isset($d['workers']))
    {
        foreach($d['workers'] as $key => $val)
        {
            if($val['action'] == "create")
            {
                $t->addStatement("INSERT INTO :prefix:worker (name, email, production, plan, shift) VALUES (:0, :1, :2, :3, :4);",
                                    htmlspecialchars($val['name']),
                                    htmlspecialchars($val['email']),
                                    $d['production'],
                                    $_POST['plan'],
                                    (int)$d['shiftId']);
            }
            else if($val['action'] == "update")
            {
                $arr = explode("\n", $val['uid']);
                $t->addStatement("UPDATE :prefix:worker SET name = :0, email = :1 
                                                            WHERE production = :2 
                                                                    AND shift = :3
                                                                    AND name = :4
                                                                    AND email = :5", 
                                                                htmlspecialchars($val['name']),
                                                                htmlspecialchars($val['email']),
                                                                $d['production'], 
                                                                $d['shiftId'],
                                                                htmlspecialchars($arr[0]),
                                                                htmlspecialchars($arr[1])
                                                                );
            }
            else
            {
                echo "unsupported action on user " . $val['name'];
            }
        }
    }

    /*
     * SAVE CHANGES TO DATABASE
     */
    $t->commit();
    
    
    /*
     * SEND EMAIL TO SUBSCRIBERS
     */
    $emailRequired = false;
    $email = new template("email");
    $email->insert("plan", $_POST['plan']);
    foreach(dbConn::query("SELECT * FROM :prefix:email_pending") as $r)
    {
        $emailRequired = true;
        foreach(dbConn::query("SELECT
                                historyId,
                                action, 
                                nameBefore, 
                                nameAfter, 
                                emailBefore, 
                                emailAfter, 
                                production, 
                                fromDate,
                                toDate,
                                mvoe_plan.name AS plan, 
                                mvoe_worker_history.created
                            FROM :prefix:worker_history 
                            INNER JOIN :prefix:shift ON :prefix:shift.shiftId = :prefix:worker_history.shift
                            INNER JOIN :prefix:plan ON :prefix:shift.plan = :prefix:plan.name
                            WHERE historyId = :0
                            ORDER BY :prefix:worker_history.created DESC", $r['historyId']) as $r)
        {
            $change = new template("admin/lastchanges.entry");
            switch($r['action'])
            {
                case "insert":
                    $change->insert("action", "<small><i class=\"fa fa-plus-square\"></i></small>  Hinzugefügt");
                    break;
                case "update":
                    $change->insert("action", "<small><i class=\"fa fa-minus-square\"></i></small>  Bearbeitet");
                    break;
                case "delete":
                    $change->insert("action", "<small><i class=\"fa fa-trash\"></i></small>  Gelöscht");
                    break;
                default:
                    $change->insert("action", "Unbekannt");
                    break;
            }
            $change->insert("shift", "<small>$r[plan], $r[production]</small><br />" .
                                    substr($r['fromDate'], 0, 5) . " - " . substr($r['toDate'], 0, 5));
            if($r['nameBefore'] == $r['nameAfter'])
                $change->insert("user", $r['nameAfter']);
            else
                $change->insert("user", "<small><span style=\"text-decoration:line-through;\">$r[nameBefore]</span></small>
                <br /><strong>$r[nameAfter]</strong>");
            if($r['emailBefore'] == $r['emailAfter'])
                $change->insert("email", $r['emailAfter']);
            else
                $change->insert("email", "<small><span style=\"text-decoration:line-through;\">$r[emailBefore]</span></small>
                <br /><strong>$r[emailAfter]</strong>");

            $change->insert("hidden", "hidden");
            $email->insert("content", $change->getOutput());
            
            dbConn::execute("DELETE FROM :prefix:email_pending WHERE historyId = :0", $r['historyId']);
        }
    }
    
    if($emailRequired)
    {
        $emailError = "";
        $arr = Array();
        foreach(dbConn::query("SELECT email FROM :prefix:email_subscriber 
                                        WHERE plan = :0", $_POST['plan']) as $r)
            $arr[] = $r['email'];
        if(count($arr) > 0 && trim($arr[0]) != "")
        {
            emailSettings::send($arr, 
                                "Änderungen am Schichtplan " . $_POST['plan'], 
                                $email->getOutput(), 
                                $emailError);
            if($emailError != "")
                throw new Exception($emailError);            
        }
    }
        
    
    echo "SUCCESS";
}
catch(Exception $ex)
{
	echo $ex->getMessage();
}


?>