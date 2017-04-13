<?php

require("../config.php");
require(BASEDIR . "admin/functions.php");

function returnResult($success, $message, $additional = null) {
    header("content-type: application/json");
    $arr = [
        "success"   => (bool) $success,
        "message"   => $message
    ];

    // check whether associative array
    if ($additional != null && array_keys($additional) !== range(0, count($additional) - 1)) {
        foreach ($additional as $k => $v) {
            $arr[$k] = $v;
        }
    }
    
	echo json_encode($arr);
	die();
}

function requireUsername() {
    if (!isset($_POST['username']) || strlen($_POST['username']) < 1)
        returnResult(false, 'Kein Benutzername angegeben');
    if (!preg_match('/^[A-Za-zäÄöÖüÜ][A-Za-z0-9äÄöÖüÜ]{3,20}$/', $_POST['username']))
        returnResult(false, 'Ungültiger Benutzername (Buchstaben, Zahlen, 4-20 Zeichen lang)');

    $nameInUse = dbConn::querySingle("SELECT COUNT(*) FROM :prefix:user WHERE name = :0", $_POST['username']) != 0;

    if ($_POST['action'] == "update") {
        if (strtolower($_POST['originalusername']) != strtolower($_POST['username'])
            && $nameInUse)
            returnResult(false, 'Benutzername <span style="font-weight: bold;">' . $_POST['username'] . '</span> wird bereits verwendet');
        if (!isset($_POST['originalusername']))
            returnResult(false, 'Unbekanntes Benutzerobjekt');
    } else if ($_POST['action'] == "create") {
        if ($nameInUse)
            returnResult(false, 'Benutzername <span style="font-weight: bold;">' . $_POST['username'] . '</span> wird bereits verwendet');
    }
}

function requirePassword() {
    if (!isset($_POST['password']) || strlen($_POST['password']) < 1)
        returnResult(false, 'Kein Passwort angegeben');
    else {
        $chars    = preg_match('@[a-zA-Z]@', $_POST['password']);
        $number   = preg_match('@[0-9]@', $_POST['password']);
        
        if(!$chars || !$number || strlen($_POST['password']) < 6 || strlen($_POST['password']) > 20)
            returnResult(false, 'Passwort nicht komplex genug (Buchstaben, Zahlen, 6-20 Zeichen lang)');
    }
}

if ($_POST['action'] == "update") {
    $changePassword = strlen($_POST['password']) > 0;
    requireUsername();
    if ($changePassword) {
        requirePassword();
    }

    try {
        if ($changePassword) {
            $salt = generateRandomString(25);
            $hash = $salt . $_POST['password'];
            $hash = hash('sha256', $hash);
            dbConn::execute("UPDATE :prefix:user SET name = :0, password = :1, salt = :2, lastchange = CURRENT_TIMESTAMP WHERE name = :3",
                $_POST['username'],
                $hash,
                $salt,
                $_POST['originalusername']
            );
        } else {
            dbConn::execute("UPDATE :prefix:user SET name = :0, lastchange = CURRENT_TIMESTAMP WHERE name = :1",
                $_POST['username'],
                $_POST['originalusername']
            );
        }

        returnResult(true, 'Der Benutzer <span style="font-weight: bold;">' . $_POST['username'] . '</span> wurde gespeichert.');
    } catch (Exception $ex) {
        returnResult(false, "Unbekannter Fehler");
    }
} else if ($_POST['action'] == "delete") {
    try {
        dbConn::execute("DELETE FROM :prefix:user WHERE name = :0", $_POST['username']);
        returnResult(true, 'Der Benutzer <span style="font-weight: bold;">' . $_POST['username'] . '</span> wurde gelöscht.');
    } catch (Exception $ex) {
        returnResult(false, "Unbekannter Fehler");
    }
    
} else if ($_POST['action'] == "create") {
    requireUsername();
    requirePassword();

    try {
            $salt = generateRandomString(25);
            $hash = $salt . $_POST['password'];
            $hash = hash('sha256', $hash);
            dbConn::execute("INSERT INTO :prefix:user (name, password, salt) VALUES (:0, :1, :2);",
                $_POST['username'],
                $hash,
                $salt
            );

            $html = "";
            foreach (dbConn::query("SELECT * FROM :prefix:user ORDER BY name ASC") as $r) {
                $html .= template::create("admin/user.row", array("name" => $r['name']));
            }

            returnResult(
                true, 
                'Der Benutzer <span style="font-weight: bold;">' . $_POST['username'] . '</span> wurde erstellt.',
                [
                    "html"  => $html
                ]
            );
    } catch (Exception $ex) {
        returnResult(false, "Unbekannter Fehler");        
    }
}

?>