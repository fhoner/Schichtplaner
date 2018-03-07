<?php

/**
 * dbConn class
 * Used for all type of queries for the database using PDO adapter.
 *
 * @author 	Felix Honer
 * @version 1.0
 */

class dbConn
{
	/**
	 * Host of the database.
	 *
	 * @var string $host
	 * @static
	 */
	private static $host;

	/**
	 * Name of the database.
	 *
	 * @var string $database
	 * @static
	 */
	private static $database;

	/**
	 * Username for database authentication.
	 *
	 * @var string $username
	 * @static
	 */
	private static $username;

	/**
	 * Password for database authentication.
	 *
	 * @var string $password
	 * @static
	 */
	private static $password;

	/**
	 * Table prefix of this cms installation.
	 *
	 * @var string $tablePrefix
	 * @static
	 */
	private static $tablePrefix;


	/**
	 * Setter of the host field.
	 *
	 * @param string $host Hostname
	 * @static
	 */
	public static function setHost($host)
	{
		dbConn::$host = $host;
	}

	/**
	 * Getter of the host field.
	 *
	 * @return string Hostname
	 * @static
	 */
	public static function getHost()
	{
		return dbConn::$host;
	}

	/**
	 * Setter of the database field.
	 *
	 * @param string $database Database
	 * @static
	 */
	public static function setDatabase($database)
	{
		dbConn::$database = $database;
	}

	/**
	 * Getter of the database field.
	 *
	 * @return string Database
	 * @static
	 */
	public static function getDatabase()
	{
		return dbConn::$database;
	}

	/**
	 * Setter of the username field.
	 *
	 * @param string $username Username
	 * @static
	 */
	public static function setUsername($username)
	{
		dbConn::$username = $username;
	}

	/**
	 * Getter of the username field.
	 *
	 * @return string Username
	 * @static
	 */
	public static function getUsername()
	{
		return dbConn::$username;
	}

	/**
	 * Setter of the password field.
	 *
	 * @param string $password Password
	 * @static
	 */
	public static function setPassword($password)
	{
		dbConn::$password = $password;
	}

	/**
	 * Getter of the password field.
	 *
	 * @return string Password
	 * @static
	 */
	public static function getPassword()
	{
		return dbConn::$password;
	}

	/**
	 * Setter of the tablePrefix field.
	 *
	 * @param string $tablePrefix Table prefix
	 * @static
	 */
	public static function setTablePrefix($prefix)
	{
		dbConn::$tablePrefix = $prefix;
	}

	/**
	 * Getter of the tablePrefix field.
	 *
	 * @return string Table prefix
	 * @static
	 */
	public static function getTablePrefix()
	{
		return dbConn::$tablePrefix;
	}

	/**
	 * Executes sql statement and returns all resulted rows. Please consider the usage
	 * of prepared statements which is fully supported.
	 *
	 * <code>
	 * <?php
	 * foeach(dbConn::Query("SELECT * FROM users WHERE username LIKE :0", "bob%") as $r)
	 * {
	 * 	   echo $r['username'];
	 * }
	 * ?>
	 *
	 * @param 	string 				$query The query in sql language.
	 * @param 	multiple strings 	The values that will fill the variables in the query.
	 * @return 	array 				All result rows as associative arrays.
	 * @static
	 */
	public static function query()
	{
		$argsCount = func_num_args();
		$par = array();

		// no query as parameter given
		if($argsCount < 1)
			throw new Exception("No Sql-Query given");

		// if there are parameters, insert in 
		if($argsCount > 1)
		{
			// create array with parameters for pdo usage
			for($i = 1; $i < $argsCount; $i++)
			{
				$key = ":" . ($i - 1);
				$par[$key] = func_get_arg($i);
			}
		}

		// insert table prefix
		$query = func_get_arg(0);
		$query = str_replace(":prefix:", dbConn::$tablePrefix, $query);

		// create pdo connection
		$db = new pdo("mysql:" .
			"host=" . dbConn::$host . ";" .
			"dbname=" . dbConn::$database . ";" . 
			"charset=UTF8",
			dbConn::$username,
			dbConn::$password);

		// prepare and execute
		$sth = $db->prepare($query, array(PDO::ATTR_CURSOR => PDO::CURSOR_FWDONLY));
		$sth->execute($par);

		// yield return results
		foreach($sth->fetchAll(PDO::FETCH_ASSOC) as $r)
		{
			yield $r;
		}


		$db = null;
	}

	/**
	 * Executes sql statement and returns a single value, if the query resulted one. Please 
	 * consider the usage of prepared statements which is fully supported.
	 *
	 * <code>
	 * <?php
	 * echo dbConn::querySingle("SELECT birthdate FROM :prefix:user WHERE name = :0", "felix honer");
	 * ?>
	 *
	 * @param 	string 				$query The query in sql language.
	 * @param 	multiple strings 	The values that will fill the variables in the query.
	 * @return 	string 				Single result value.
	 * @static
	 */
	public static function querySingle()
	{
		$result = null;
		$argsCount = func_num_args();
		$par = array();

		// no query as parameter given
		if($argsCount < 1)
			throw new Exception("No Sql-Query given");

		// if there are parameters, insert in 
		if($argsCount > 1)
		{
			// create array with parameters for pdo usage
			for($i = 1; $i < $argsCount; $i++)
			{
				$key = ":" . ($i - 1);
				$par[$key] = func_get_arg($i);
			}
		}

		// insert table prefix
		$query = func_get_arg(0);
		$query = str_replace(":prefix:", dbConn::$tablePrefix, $query);

		// create pdo connection
		$db = new pdo("mysql:" .
			"host=" . dbConn::$host . ";" .
			"dbname=" . dbConn::$database . ";" . 
			"charset=UTF8",
			dbConn::$username,
			dbConn::$password);

		// prepare and execute
		$sth = $db->prepare($query, array(PDO::ATTR_CURSOR => PDO::CURSOR_FWDONLY));
		$sth->execute($par);

		// yield return results
		foreach($sth->fetchAll() as $r)
		{
			if(isset($r[0]))
			{
				$result = $r[0];
				break;
			}
		}

		// close database connection
		$db = null;

		// return single row result
		return $result;
	}
	
	/**
	 * Executes sql statement without any return value. Please consider the usage of 
	 * prepared statements which is fully supported.
	 *
	 * <code>
	 * <?php
	 * dbConn::execute("INSERT INTO :prefix:user (username, registered) VALUES (:0, :1);", 'felix', (new DateTime));
	 * ?>
	 *
	 * @param 	string 				$query The query in sql language.
	 * @param 	multiple strings 	The values that will fill the variables in the query.
	 * @static
	 */
	public static function execute()
	{
		$argsCount = func_num_args();
		$par = array();

		// no query as parameter given
		if($argsCount < 1)
			throw new Exception("No Sql-Query given");

		// if there are parameters, insert in 
		if($argsCount > 1)
		{
			// create array with parameters for pdo usage
			for($i = 1; $i < $argsCount; $i++)
			{
				$key = ":" . ($i - 1);
				$par[$key] = func_get_arg($i);
			}
		}

		// insert table prefix
		$query = func_get_arg(0);
		$query = str_replace(":prefix:", dbConn::$tablePrefix, $query);

		// create pdo connection
		$db = new pdo("mysql:" .
			"host=" . dbConn::$host . ";" .
			"dbname=" . dbConn::$database . ";" . 
			"charset=UTF8",
			dbConn::$username,
			dbConn::$password);
		$db->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

		try
		{			
			// prepare and execute
			$sth = $db->prepare($query, array(PDO::ATTR_CURSOR => PDO::CURSOR_FWDONLY));
			if(!$sth)
				throw new Exception($db->errorInfo());
			$sth->execute($par);
		}
		catch(Exception $ex)
		{
			throw new Exception($ex->getMessage());
		}

		// close database connection
		$db = null;
	}
    
	/**
	 * Executes sql statement and returns single row. If the query results more than one row, the
	 * last row in order of the database result will be returned. Please consider the usage of
	 * prepared statements which is fully supported.
	 *
	 * <code>
	 * <?php
	 * $row = dbConn::queryRow("SELECT * FROM :prefix:user WHERE username = :0 AND password = :1", 'felix', 'secur3');
	 * echo $row['username'];
	 * echo $row['registered'];
	 * ?>
	 *
	 * @param 	string 				$query The query in sql language.
	 * @param 	multiple strings 	The values that will fill the variables in the query.
	 * @return 	array 				Associative array with column names as indices.
	 * @static
	 */
	public static function queryRow()
	{
		$argsCount = func_num_args();
		$par = array();

		// no query as parameter given
		if($argsCount < 1)
			throw new Exception("No Sql-Query given");

		// if there are parameters, insert in 
		if($argsCount > 1)
		{
			// create array with parameters for pdo usage
			for($i = 1; $i < $argsCount; $i++)
			{
				$key = ":" . ($i - 1);
				$par[$key] = func_get_arg($i);
			}
		}

		// insert table prefix
		$query = func_get_arg(0);
		$query = str_replace(":prefix:", dbConn::$tablePrefix, $query);

		// create pdo connection
		$db = new pdo("mysql:" .
			"host=" . dbConn::$host . ";" .
			"dbname=" . dbConn::$database . ";" . 
			"charset=UTF8",
			dbConn::$username,
			dbConn::$password);

		// prepare and execute
		$sth = $db->prepare($query, array(PDO::ATTR_CURSOR => PDO::CURSOR_FWDONLY));
		$sth->execute($par);

		// yield return results
        $result = null;
		foreach($sth->fetchAll() as $r)
		{
			$result = $r;
            break;
		}
        
        if(is_array($result))
        {
	        foreach ($result as $key => $value) 
	        {
	            if (is_int($key)) 
	            {
	                unset($result[$key]);
	            }
	        }        	
        }

        return $result;
	}

    public static function testConnection() {
        try {
            $db = new pdo("mysql:" .
                "host=" . dbConn::$host . ";" .
                "dbname=" . dbConn::$database . ";" .
                "charset=UTF8",
                dbConn::$username,
                dbConn::$password
            );
            return true;
        }
        catch (PDOException $ex) {
            return false;
        }
    }
}

?>