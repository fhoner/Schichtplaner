<?php

session_start();

require("../config.php");
require(BASEDIR . "functions.php");

if (!isLoggedin()) {
    die(json_encode(array(
        "success"   => false,
        "message"   => "Unauthentifizierter Benutzer"
    )));
}

$workers = [];

foreach (dbConn::query("SELECT name, email, isFixed FROM :prefix:worker WHERE
                            plan = :0 AND
                            production = :1 AND
                            shift = :2
                        ORDER BY position ASC",
    $_POST['plan'],
    $_POST['production'],
    $_POST['shiftId']    
) as $r) {
    $r['isFixed'] = (bool) $r['isFixed'];
    $workers[] = $r;
}

header("content-type: application/json");
echo json_encode(array(
    "success"       => true,
    "workers"       => $workers,
    "autocomplete"  => Schichtplaner\PersistenceService::getAllWorkers()
));

?>