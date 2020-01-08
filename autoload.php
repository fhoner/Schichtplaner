<?php

require_once(BASEDIR . "dbConn.php");
require_once(BASEDIR . "functions.php");
require_once(BASEDIR . "transaction.php");
require_once(BASEDIR . "template.php");
require_once(BASEDIR . "emailSettings.php");
require_once(BASEDIR . "vendor/autoload.php");

require_once(BASEDIR . "/Schichtplaner/ConfigReader.php");
require_once(BASEDIR . "/Schichtplaner/PersistenceService.php");
require_once(BASEDIR . "/Schichtplaner/ShiftMerger.php");

require_once(BASEDIR . "/Schichtplaner/authentication/AuthProvider.php");
require_once(BASEDIR . "/Schichtplaner/authentication/DatabaseAuthProvider.php");
require_once(BASEDIR . "/Schichtplaner/authentication/JiraRestAuthProvider.php");
require_once(BASEDIR . "/Schichtplaner/authentication/AuthController.php");

use Schichtplaner\ConfigReader;

dbConn::setHost(ConfigReader::getConfigOption('database/host'));
dbConn::setDatabase(ConfigReader::getConfigOption('database/name'));
dbConn::setUsername(ConfigReader::getConfigOption('database/user'));
dbConn::setPassword(ConfigReader::getConfigOption('database/password'));
dbConn::setTablePrefix(ConfigReader::getConfigOption('database/prefix'));

emailSettings::setHost(ConfigReader::getConfigOption('email/host'));
emailSettings::setUsername(ConfigReader::getConfigOption('email/user'));
emailSettings::setPassword(ConfigReader::getConfigOption('email/password'));
emailSettings::setSender(ConfigReader::getConfigOption('email/sender'));
emailSettings::setMethod(ConfigReader::getConfigOption('email/method') === 'mail' ? emailSendMethod::MAIL : emailSendMethod::PHPMAILER);
