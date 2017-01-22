<?php

require("../config.php");
require("../frontend.php");

$cssfile = BASEDIR . $_GET['filename'] . ".css";
$minCssfile = BASEDIR . str_replace(".css", ".min.css", $_GET['filename'] . ".css");


$create = false;

if(!file_exists($minCssfile) ||	// no .min.css exists
	filemtime($cssfile) > filemtime($minCssfile))	// existing .min.css is older than the original
{
    $js = "";
    $js .= "/*\r\n";
    $js .= " * CSS minified by FHoner CMS - " . (new DateTime())->format("d.m.y H:m") . "\r\n";
    $js .= " */\r\n\r\n\r\n";
	$js .= frontend::minifyJs(file_get_contents($cssfile));
    
	file_put_contents($minCssfile, $js);
}

header('Content-Type: text/css');
header('Content-Length: ' . filesize($minCssfile));
print file_get_contents($minCssfile);

?>