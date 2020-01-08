<?php

namespace Schichtplaner\Authentication;

use dbConn;
use Schichtplaner\ConfigReader;

class AuthController {

    private $authProvider;

    public function __construct() {
        switch (ConfigReader::getConfigOption('auth/type')) {
            case 'database':
                $this->authProvider = new DatabaseAuthProvider();
                break;
            case 'jira':
                $this->authProvider = new JiraRestAuthProvider();
                break;
            default:
                throw new \Exception('unknown auth type configured');
        }
    }

    public function authenticate(string $username, string $password): array {
        try {
            $this->validateCredentials($username, $password);
        } catch (\Exception $ex) {
            return [
                'success' => false,
                'message' => $ex->getMessage()
            ];
        }

        $authSuccess = $this->authProvider->authorize($username, $password);

        if ($authSuccess === true) {
            dbConn::execute("UPDATE :prefix:user SET lastlogin = CURRENT_TIMESTAMP WHERE name = :0", $username);
            $_SESSION['user'] = $username;
            $_SESSION['userData'] = [
                'name' => $username,
                'lastchange'
            ];
            return [
                'success' => true,
                'username' => $username
            ];
        }

        return [
            'success' => false,
            'message' => 'Die Benutzerdaten stimmen nicht überein.'
        ];
    }

    private function validateCredentials(string $username, string $password): void {
        if (!isset($username) || strlen($username) < 1 ||
            !isset($password) || strlen($password) < 1) {
            throw new \Exception('Geben Sie Benutzername und Passwort ein.');
        }
    }

}
