<?php

session_start();

unset($_SESSION['user']);
unset($_SESSION['userData']);
unset($_SESSION);

echo json_encode(array(
    "success"   => true
));

?>