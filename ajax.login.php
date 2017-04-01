<?php

session_start();

require("config.php");
require("functions.php");
require("transaction.php");

$errors = array();

function showFailure() {
	die(json_encode(array(
	        "success"   => false,
	        "message"   => "Die Benutzerdaten stimmen nicht überein."
	    )));
}

if (!isset($_POST['username']) || strlen($_POST['username']) < 1) {
	$errors[] = "Geben Sie einen Benutzernamen ein.";
}
if (!isset($_POST['password']) || strlen($_POST['password']) < 1) {
	$errors[] = "Geben Sie ein Passwort ein.";
}

$user = dbConn::queryRow("SELECT * FROM :prefix:user WHERE name = :0", $_POST['username']);

if ($user == null) {
	showFailure();
}

$hash = hash('sha256', $user['salt'] . $_POST['password']);
$dbResultCount = dbConn::querySingle("SELECT COUNT(*) FROM :prefix:user WHERE name = :0 AND password = :1", 
    $_POST['username'], $hash);
if ($dbResultCount < 1) {
	showFailure();
} else {
	dbConn::execute("UPDATE :prefix:user SET lastlogin = CURRENT_TIMESTAMP WHERE name = :0", $user['name']);
    $_SESSION['user'] = $user['name'];
    $_SESSION['userData'] = $user;
    die(json_encode(array(
	        "success"   => true,
            "username"  => $user['name']
	    )));
}


?>