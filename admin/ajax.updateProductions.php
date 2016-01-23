<?php

/*


Array
(
     [data] => Array
            (
                [0] => Array
                    (
                        [uid] => Pommes
                        [name] => Pommes
                        [master] => Array
                            (
                                [name] => 'Felix Honer'
                                [email] => 'privat@felix-honer.com'
                            )
                        [shifts] => Array
                            (
                                [0] => Array
                                    (
                                        [id] => 3
                                        [max] => 2
                                        [checked] => 'true'
                                    )

                                [1] => Array
                                    (
                                        [id] => 3
                                        [max] => 2
                                        [checked] => 'false'
                                    )
                            )
                    )
            )
     [plan]  => "Donnerstag"
)

 */

/*echo "<pre>" . json_encode($_POST, JSON_PRETTY_PRINT) . "</pre>";
die();*/

require("../config.php");
require("../transaction.php");

$t = new transaction();
try
{
    // delete removed productions
    foreach(dbConn::query("SELECT * FROM :prefix:production WHERE plan = :0", $_POST['plan']) as $r)
    {
        $deleted = true;
        if(isset($_POST['data']))
        {
            foreach($_POST['data'] as $key => $val)
            {
                if($r['name'] == $val['uid'])
                    $deleted = false;
            }            
        }
        if($deleted) 
        {
            $t->addStatement("DELETE FROM :prefix:production WHERE plan = :0 AND name = :1", $_POST['plan'], $r['name']);
        }
    }
    
    // update existing productions
    if(isset($_POST['data']))
    {
        foreach($_POST['data'] as $key => $val)
        {
            $t->addStatement("UPDATE :prefix:production SET name = :0, masterName = :1, masterEmail = :2
                              WHERE name = :3 AND plan = :4", 
                             $val['name'], 
                             $val['master']['name'] == "" ? null : $val['master']['name'],
                             $val['master']['email'] == "" ? null : $val['master']['email'],
                             $val['uid'], 
                             $_POST['plan']);

            foreach($val['shifts'] as $sk => $sv)
            {
                if($sv['checked'] == "true")
                {
                    $t->addStatement("REPLACE INTO :prefix:production_shift (production, shift, plan, required) VALUES (:0, :1, :2, :3);", 
                                        $val['name'],
                                        $sv['id'],
                                        $_POST['plan'],
                                        $sv['max']
                                   );
                }
                else
                {
                    $t->addStatement("DELETE FROM :prefix:production_shift WHERE production = :0 AND shift = :1",
                                        $val['name'],
                                        $sv['id']
                                    );
                }            
            }

        }
    }

    $t->commit();
    echo "SUCCESS";
}
catch(Exception $ex)
{
    $t->rollback();
    echo "<p>Änderungen konnten nicht gespeichert werden.</p><p>Mögliche Fehler sind:</p><ul>" .
        "<li>es wurde eine Produktion gelöscht, die noch zugewiesene Schichten besitzt</li>" .
        "<li>es wurde eine Schicht von einer Produktion entfernt, der noch Helfer zugewiesen sind</li></ul><br><br>";
    echo $ex->getMessage();
}


//print_r($_POST);

?>