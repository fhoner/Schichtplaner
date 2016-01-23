<?php

/*
 * transaction class
 * creates an transaction object for databases, which will be invoked through dbConn-class
 * Felix Honer
 * 2014/10/29
 *
 */

class transaction
{
	private $connection;
	private $exception;

	public function __construct()
	{
		$this->exception = null;

		// create pdo connection
		$this->connection = new pdo("mysql:" .
			"host=" . dbConn::getHost() . ";" .
			"dbname=" . dbConn::getDatabase() . ";" . 
			"charset=UTF8",
			dbConn::getUsername(),
			dbConn::getPassword());

		$this->connection->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

		$this->connection->beginTransaction();
	}

	public function addStatement()
	{
		$argsCount = func_num_args();
		$par = array();	// array with parameters; will be used later for prepare/exec

		// no query as parameter given
		if($argsCount < 1)
			throw new Exception("No Sql-Query given");

		// insert table prefix
		$query = func_get_arg(0);
		$query = str_replace(":prefix:", dbConn::getTablePrefix(), $query);

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

		try
		{
			// prepare statement
			$statement = $this->connection->prepare($query);
			$statement->execute($par);
		}
		catch(Exception $ex)
		{
			throw new Exception($ex->getMessage());
		}

		// return current object for reusage
		return $this;
	}

	public function commit()
	{
		try
		{
			$this->connection->commit();
			return true;
		}
		catch(Exception $ex)
		{
			$this->connection->rollBack();
			$this->exception = $ex;
			return false;
		}
	}

	public function rollback()
	{
		try
		{
			$this->connection->rollBack();
			return true;
		}
		catch(Exception $ex)
		{
			$this->exception = $ex;
			return false;
		}
	}

	public function getException()
	{
		return $this->exception;
	}
}

?>