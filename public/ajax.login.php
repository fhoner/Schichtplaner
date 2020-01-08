<?php

session_start();

require "../config.php";
require "../autoload.php";

use Schichtplaner\Authentication\AuthController;

$authController = new AuthController();
$authResult = $authController->authenticate($_POST['username'], $_POST['password']);

echo json_encode($authResult);
