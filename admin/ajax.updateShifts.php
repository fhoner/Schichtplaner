<?php

require("../config.php");
require("../transaction.php");

/*

Array
(
    [data] => Array
        (
            [deleted] => Array
                (
                    [0] => 9
                    [1] => 1
                    [2] => 5
                )

            [updated] => Array
                (
                    [0] => Array
                        (
                            [id] => 8
                            [from] => 12:00:00
                            [to] => 17:00:00
                        )

                    [1] => Array
                        (
                            [id] => 2
                            [from] => 14:00:00
                            [to] => 18:30:00
                        )
                )
        )
)

 */

try
{
    $t = new transaction();

    if(isset($_POST['data']['deleted']))
    {
        foreach($_POST['data']['deleted'] as $del)
        {
            $t->addStatement("DELETE FROM :prefix:shift WHERE shiftId = :0", $del);
        }
    }

    if(isset($_POST['data']['updated']))
    {
        foreach($_POST['data']['updated'] as $up)
        {
            $t->addStatement("UPDATE :prefix:shift SET fromDate = :0, toDate = :1 WHERE shiftId = :2", 
                                $up['from'],
                                $up['to'],
                                $up['id']
                            );
        }
    }        

    $t->commit();
    echo "SUCCESS";
}
catch(Exception $ex)
{
    echo $ex->getMessage();
}


?>