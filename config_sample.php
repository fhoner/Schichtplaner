<?php

/* HOST SETUP */
DEFINE("URL", "http://localhost/schichtplaner");                    // full url
DEFINE("BASEDIR", $_SERVER['DOCUMENT_ROOT'] . "/schichtplaner/");	// base dir of cms including document root
DEFINE("ROOT", "/schichtplaner/");									// base dir of cms without document root
DEFINE("ORGANISATION", "Organisazion Ltd.");                        // organisation name

DEFINE("SCHICHTPLANER", [
    'database' => [
        'host'      => 'localhost',
        'name'      => 'schichtplaner',
        'user'      => 'root',
        'password'  => 'root',
        'prefix'    => 'planer_'
    ],
    'email' => [
        'host'      => 'localhost',
        'user'      => 'user@domain.com',
        'password'  => '53cu3',
        'sender'    => 'info@domain.com',
        'method'    => 'phpmailer', // 'mail' or 'phpmailer'
    ],
    'auth' => [
        'type'  => 'jira', // 'database' or 'jira'
        'parameters' => [ // only needed when using jira auth mode
            'url'       => 'https://jira.mydomain.com',
            'memberOf'  => 'schichtplaner-users'
        ]
    ]
]);

/* DO NOT CHANGE */
DEFINE("TEMPLATEDIR", BASEDIR . "template/");
DEFINE("PLUGINDIR", BASEDIR . "plugins/");
DEFINE("FRONTENDURL", URL);
