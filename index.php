<?php

session_start();

require("config.php");
require("autoload.php");

echo template::create("index", array(
    "organisation"          => ORGANISATION,
    "username"              => isset($_SESSION['userData']) ? $_SESSION['userData']['name'] : "",
    "loggedIn"              => isLoggedin() ? "true" : "false",
    "login-input-visible"   => isLoggedin() ? 'style="display:none;"' : "",
    "logout-input-visible"  => !isLoggedin() ? 'style="display:none;"' : "",
    "version"               => getVersionString()
));
