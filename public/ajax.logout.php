<?php

session_start();

unset($_SESSION['user']);
unset($_SESSION['userData']);

session_destroy();

echo json_encode(array(
    "success"   => true
));

?>