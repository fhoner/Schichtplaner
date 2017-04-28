<?php

/**
 * Makes a string URL valid by removing unallowed characters.
 *
 * @param string $string The string to make URL valid.
 * @return string URL valid string.
 */
function seoUrl($string) {    
    $string = preg_replace("/[^a-zA-Z0-9_\s-]/", "", $string);  // Make alphanumeric (removes all other characters)
    $string = preg_replace("/[\s-]+/", " ", $string);   // Clean up multiple dashes or whitespaces
    $string = preg_replace("/[\s_]/", "-", $string);    // Convert whitespaces and underscore to dash
    return $string;
}

/**
 * Makes a uid string.
 *
 * @param string $plan Name of the plan.
 * @param string $production Name of the production.
 * @param string $fromDate begin date.
 * @param string $toDate end date.
 *
 * @return string Valid string ready for usage as css id.
 */
function makeUid($plan, $production, $fromDate, $toDate) {
    return seoUrl(
            $plan . "-" .
            $production . "-"
        ) .
        substr($fromDate, 0, 5) . "-" .
        substr($toDate, 0, 5);
}

/**
 * Checks whether user is currently logged in or not.
 *
 * @return boolean True if a user is logged in, false otherwise.
 */
function isLoggedin() {
    if (!isset($_SESSION['user']) || !isset($_SESSION['userData']))
        return false;

    $userdb = dbConn::queryRow("SELECT * FROM :prefix:user WHERE name = :0", $_SESSION['user']);
    $logout = $userdb == null || $_SESSION['userData']['lastchange'] != $userdb['lastchange'];
    return isset($_SESSION['user']) && !$logout;
}

/**
 * Prints a json result object and stops the script.
 *
 * @param boolean $success Boolean whether operation was done successfully or failed.
 * @param string $message A message for user frontend.
 * @param array $additional {
 *      An associative array for any further key-value pairs.
 *
 *      @type string $key
 *      @type object $value
 *}
 */
function returnResult($success, $message, $additional = null) {
    $arr = [
        "success"   => (bool) $success
    ];

    if (strlen($message) > 0) {
        $arr['message'] = $message;
    }

    if ($additional != null && array_keys($additional) !== range(0, count($additional) - 1)) {
        foreach ($additional as $k => $v) {
            $arr[$k] = $v;
        }
    }
    
    header("content-type: application/json");
	echo json_encode($arr);
	die();
}

?>