<?php

require("../config.php");

if($_POST['name'] == "")
    die("Bitte geben Sie einen Namen ein.");

if(dbConn::querySingle("SELECT COUNT(*) FROM :prefix:production WHERE plan = :0 AND name = :1",
                        htmlspecialchars($_POST['plan']),
                        htmlspecialchars($_POST['name'])
                      ) > 0)
    die("Der Name ist bereits vergeben.");

dbConn::execute("INSERT INTO :prefix:production (plan, name) VALUES (:0, :1);",
                htmlspecialchars($_POST['plan']),
                htmlspecialchars($_POST['name'])
               );

echo "SUCCESS";

?>