<?php

namespace Schichtplaner\Authentication;

use dbConn;

class DatabaseAuthProvider implements AuthProvider {

    public function authorize($username, $password): bool {
        $user = dbConn::queryRow("SELECT * FROM :prefix:user WHERE name = :0", $_POST['username']);
        if ($user == null) {
            return false;
        }

        $hash = hash('sha256', $user['salt'] . $_POST['password']);
        $dbResultCount = dbConn::querySingle("SELECT COUNT(*) FROM :prefix:user WHERE name = :0 AND password = :1", $_POST['username'], $hash);
        if ($dbResultCount < 1) {
            return false;
        }

        return true;
    }


}
