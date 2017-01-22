<?php

require("../config.php");
require(BASEDIR . "transaction.php");

function validateDate($date)
{
    $d = DateTime::createFromFormat('d.m.Y', $date);
    return $d && $d->format('d.m.Y') == $date;
}

if(!isset($_POST['name']) || strlen($_POST['name']) < 1)
    die("Bitte geben Sie einen gültigen Namen ein.");

if(!isset($_POST['public']) || !validateDate($_POST['public'])
  || !isset($_POST['editable']) || !validateDate($_POST['editable']))
    die("Bitte geben Sie ein gültiges Datum ein.");

dbConn::execute("UPDATE :prefix:plan SET name = :0, public = :1, editable = :2 WHERE name = :3",
    htmlspecialchars($_POST['name']),
    DateTime::createFromFormat("d.m.Y", $_POST['public'])->format("Y-m-d H:i:s"),
    DateTime::createFromFormat("d.m.Y", $_POST['editable'])->format("Y-m-d H:i:s"),
    htmlspecialchars($_POST['originalName'])
);

$subscribers = new transaction();
$subscribers->addStatement("DELETE FROM :prefix:email_subscriber WHERE plan = :0;", htmlspecialchars($_POST['name']));
foreach ($_POST['subscribers'] as $mail) {
    $subscribers->addStatement("INSERT INTO :prefix:email_subscriber (email, plan) VALUES (:0, :1);",
        htmlspecialchars($mail),
        htmlspecialchars($_POST['name'])
    );
}
$subscribers->commit();


echo "SUCCESS";

?>