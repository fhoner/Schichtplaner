<?php


/* HOST SETUP */
DEFINE("URL", "http://localhost/");                   // full url
DEFINE("BASEDIR", $_SERVER['DOCUMENT_ROOT'] . "/");	// base dir of cms including document root
DEFINE("ROOT", "/");									// base dir of cms without document root
DEFINE("ORGANISATION", "Organisazion Ltd.");                // organisation name
DEFINE("WEBMASTER", "info@domain.de");                      // email of webmaster

/* REQUIRED */
require("dbConn.php");
require("template.php");
require("emailSettings.php");
require("Schichtplaner/autoload.php");
require("vendor/autoload.php");

/* DATABASE SETUP */
dbConn::setHost(getenv("DB_HOST"));
dbConn::setDatabase(getenv("DB_NAME"));
dbConn::setUsername(getenv("DB_USER"));
dbConn::setPassword(getenv("DB_PASSWORD"));
dbConn::setTablePrefix(getenv("DB_PREFIX"));

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