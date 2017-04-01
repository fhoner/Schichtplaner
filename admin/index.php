<?php

require("../config.php");
require("../functions.php");

$tpl = new template("admin/index");

// plans in navigation
foreach(dbConn::query("SELECT * FROM :prefix:plan WHERE deleted = 0 ORDER BY created DESC") as $r)
{
    $t = new template("admin/nav.plan");
    $t->insert("name", $r['name']);
    if(isset($_GET['v']) 
       && $_GET['v'] == "plan" 
       && isset($_GET['p']) 
       && $_GET['p'] == $r['name'])
        $t->insert("active", "active");
    else
        $t->insert("active", "");
    $tpl->insert("navPlans", $t->getOutput());
}


$tpl->removeVariables();
echo $tpl->getOutput();

?>