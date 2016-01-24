<?php

require("../config.php");
require("../frontend.php");

$jsfile = BASEDIR . $_GET['filename'] . ".js";
$minJsfile = BASEDIR . str_replace(".js", ".min.js", $_GET['filename'] . ".js");


$create = false;

if(!file_exists($minJsfile) ||	// no .min.js exists
	filemtime($jsfile) > filemtime($minJsfile))	// existing .min.js is older than the original
{
    $js = "";
    $js .= "//\r\n";
    $js .= "// JS minified by FHoner CMS - " . (new DateTime())->format("d.m.y H:m") . "\r\n";
    $js .= "//\r\n\r\n\r\n";
	$js .= frontend::minifyJs(file_get_contents($jsfile));
    
	file_put_contents($minJsfile, $js);
}

header('Content-Type: application/javascript');
header('Content-Length: ' . filesize($minJsfile));
print file_get_contents($minJsfile);

?>