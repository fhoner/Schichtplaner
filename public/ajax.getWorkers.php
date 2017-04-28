<?php

session_start();

require("../config.php");
require(BASEDIR . "functions.php");
require(BASEDIR . "transaction.php");

if (!isLoggedin()) {
    die(json_encode(array(
        "result"    => "ERROR",
        "message"   => "Unauthentifizierter Benutzer"
    )));
}

$arr = [];
foreach (dbConn::query("SELECT DISTINCT w.name, w.email  FROM `schichtplaner_worker` as w
                        INNER JOIN schichtplaner_plan AS p ON w.plan = p.name
                        WHERE p.deleted = 0") as $r) {
    $arr[] = $r;
}

header("content-type: application/json");
die(json_encode(array(
    "success"   => true,
    "workers"   => $arr
)));


?>