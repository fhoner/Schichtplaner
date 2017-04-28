<?php

/* HOST SETUP */
DEFINE("URL", "http://localhost/planer");                   // full url
DEFINE("BASEDIR", $_SERVER['DOCUMENT_ROOT'] . "/planer/");	// base dir of cms including document root
DEFINE("ROOT", "/planer/");									// base dir of cms without document root
DEFINE("ORGANISATION", "Organisazion Ltd.");                // organisation name
DEFINE("WEBMASTER", "info@domain.de");                      // email of webmaster

/* REQUIRED */
require("dbConn.php");
require("template.php");
require("emailSettings.php");
require("Schichtplaner/autoload.php");
require("vendor/autoload.php");

/* DATABASE SETUP */
dbConn::setHost("localhost");
dbConn::setDatabase("planer");
dbConn::setUsername("root");
dbConn::setPassword("root");
dbConn::setTablePrefix("planer_");

/* EMAIL SETUP */
emailSettings::setHost("localhost");
emailSettings::setUsername("user@domain.com");
emailSettings::setPassword("53cur3");
emailSettings::setSender(WEBMASTER);
emailSettings::setMethod(emailSendMethod::PHPMAILER);

/* DO NOT CHANGE */
DEFINE("TEMPLATEDIR", BASEDIR . "template/");
DEFINE("PLUGINDIR", BASEDIR . "plugins/");
DEFINE("FRONTENDURL", URL);

?>