<?php

require("../config.php");

dbConn::execute("UPDATE :prefix:plan SET deleted = 1, name = CONCAT(name, '_', CURRENT_TIMESTAMP) WHERE name = :0", 
                $_POST['plan']);
echo "SUCCESS";

?>