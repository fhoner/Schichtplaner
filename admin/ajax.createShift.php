<?php

require("../config.php");

function validateDate($date)
{
    $d = DateTime::createFromFormat('H:i', $date);
    return $d && $d->format('H:i') == $date;
}

$plan = $_POST['plan'];
$_POST = $_POST['data'];

if(!validateDate($_POST['from']) || !validateDate($_POST['to']))
    die("Bitte geben Sie ein gültiges Zeitformat ein.");

if($_POST['to'] == $_POST['from'])
    die("Anfang und Ende dürfen nicht identisch sein.");

if(strtotime($_POST['to']) < strtotime($_POST['from']))
    die("Der Anfang muss vor dem Ende liegen.");

if(dbConn::querySingle("SELECT COUNT(*) FROM :prefix:shift WHERE plan = :0 AND fromDate = :1 AND toDate = :2",
                        $plan,
                        $_POST['from'],
                        $_POST['to']
                      ) > 0)
    die("Eine Schicht mit den eingegebenen Zeiten existiert bereits für diesen Plan.");

dbConn::execute("INSERT INTO :prefix:shift (plan, fromDate, toDate) VALUES (:0, :1, :2)",
                $plan,
                $_POST['from'],
                $_POST['to']
               );

echo "SUCCESS";

?>
