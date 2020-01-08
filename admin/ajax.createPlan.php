<?php

require("../config.php");

function validateDate($date)
{
    $d = DateTime::createFromFormat('d.m.Y', $date);
    return $d && $d->format('d.m.Y') == $date;
}

if(!isset($_POST['name']) || strlen($_POST['name']) < 1)
    die("Bitte geben Sie einen gültigen Namen ein.");
if(dbConn::querySingle("SELECT COUNT(*) FROM :prefix:plan WHERE name = :0", $_POST['name']) > 0)
    die("Der eingegebene Name ist schon vergeben.");

if(!isset($_POST['public']) || !validateDate($_POST['public'])
  || !isset($_POST['editable']) || !validateDate($_POST['editable']))
    die("Bitte geben Sie ein gültiges Datum ein.");

dbConn::execute("INSERT INTO :prefix:plan (name, public, editable) VALUES (:0, :1, :2);",
                htmlspecialchars($_POST['name']),
                $_POST['public'],
                $_POST['editable']);

$tpl = new template("admin/nav.plan");
$tpl->insert("active", "");
$tpl->insert("name", htmlspecialchars($_POST['name']));
echo "SUCCESS" . $tpl->getOutput();

?>
