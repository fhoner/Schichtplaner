<?php

/**
 * template class
 * Used to create html output with predefined template files. Template files can 
 * contain variables. The template class helps filling template files with content.
 *
 * @author Felix Honer
 * @version 1.8 (2015-12-03)
 *
 */


class template
{
	/**
	 * The directory where the template is located.
	 *
	 * @var string $template_directory
	 * @static
	 */
	private static $template_directory = TEMPLATEDIR;

	/**
	 * The file extension of the template files.
	 *
	 * @var string $template_file_extension
	 * @static
	 */
	private static $template_file_extension = ".tpl";

	/**
	 * The beginning character sequence how template variables begin.
	 *
	 * @var string $template_variable_beginning_char
	 * @static
	 */
	private static $template_variable_beginning_char = '${';

	/**
	 * The ending character sequence how template variables end.
	 *
	 * @var string $template_variable_ending_char
	 * @static
	 */
	private static $template_variable_ending_char = '}$';	

	/**
	 * The directory where the plugins are located.
	 *
	 * @var string $plugin_directory
	 * @static
	 */
	private static $plugin_directory = PLUGINDIR;

	/**
	 * The ending character sequence how plugin variables begin
	 *
	 * @var string $plugin_directory
	 * @static
	 */
	private static $plugin_variable_beginning_char = '%{';

	/**
	 * The ending character sequence how plugin variables begin
	 *
	 * @var string $plugin_directory
	 * @static
	 */
	private static $plugin_variable_ending_char = '}%';	

	/**
	 * Template constants which always will automatically be inserted in every 
     * output. Feel free to add several more.
	 *
	 * @var array $template_constants
	 * @static
	 */
	private static $template_constants = array(
			array("root", ROOT),
            array("url", URL),
            array("frontendurl", FRONTENDURL)
		);

    /**
     * The html output content.
     *
     * @var string $output
     */
	private $output;
    
    /**
     * Name of the template file without the template file extension.
     *
     * @var string $template_file_name
     */
	private $template_file_name;
    
    /**
     * Contains random hashes linked to the variable name. If an variable
     * is used for the first time, the variable name will be replaced by
     * a random generated hash.
     *
     * @var array $variable_hashes
     */
	private $variable_hashes;
    
    /**
     * Indicates whether auto indention of html output is enabled or not.
     *
     * @var bool $doIndent
     * @static
     * @since Version 1.6
     */
    private static $doIndent = false;
    
    /**
     * Setter of the doIndent field.
     *
     * @param boolean $enabled
     * @static
     * @since Version 1.6
     */
    public static function setDoIndent($enabled)
    {
        template::$doIndent = (bool)$enabled;
    }
    
    /**
     * Getter of the doIndent field.
     *
     * @return bool
     * @static
     * @since Version 1.6
     */
    public static function getDoIndent()
    {
        return template::$doIndent;
    }
    
	/**
     * The constructor which directly will open the given file name 
     * and load its content.
     *
     * @param string $template_file Name of the template file without the file extension.
     */
	public function __construct($template_file)
	{
		$this->variable_hashes = array();
        $this->template_file_name = $template_file . ".tpl";

		if($template_file[0] != '/')
			$template_file = template::$template_directory . $template_file;
		$template_file .=  template::$template_file_extension;

		if(!file_exists($template_file))
		{
			throw new Exception("Die Template-Datei konnte nicht gefunden werden: <strong>" . $template_file . "</strong>");
		}

		$this->output = file_get_contents($template_file);
		$this->insertTemplateConstants();
	}

    /**
     * Replaces the template constant variables with the defined values.
     *
     * @since Version 1.1
     */
	private function insertTemplateConstants()
	{
		foreach(template::$template_constants as $c)
		{
			$this->output = str_replace(
				template::$template_variable_beginning_char . template::$template_variable_beginning_char . $c[0] . template::$template_variable_ending_char . template::$template_variable_ending_char, 
				$c[1], $this->output);
		}

		$this->output = str_replace(
			template::$template_variable_beginning_char . template::$template_variable_beginning_char . 
				"user" .
				template::$template_variable_ending_char . template::$template_variable_ending_char, 
			isset($_SESSION['user']) ? $_SESSION['user'] : "-1", 
			$this->output);
	}

    /**
     * Replaces variables with the given content.
     *
     * @param string $variable  Variable name inside the template file.
     * @param string $content   Content to fill.
     * @since Version 1.0
     */
	public function insert($variable, $content)
	{
        // if $content ist instance of template, then call getOutput method to retrieve string from it
        if($content instanceof template)
            $content = $content->getOutput();
        
		// TO DO !!!!
		// check here if content is equal to any key which is in use 
		// if so, create new key and replace old, to prevent key is used in document multiple times

		// search for key in temp_variables
		if(!array_key_exists($variable, $this->variable_hashes))
		{
			$created = false;

			do
			{
				// create new random key
				$key = hash("md5", uniqid());
				$created = true;

				// document contains key
				if(strpos($this->output, $key) !== false || strpos($content, $key) !== false)
				{
					$created = false;
				}				
			}
			while (!$created); 	// unique key created (whether document nor given content contains this key)

			// add key to temp variable
			$this->variable_hashes[$variable] = $key;

			// insert content and place created key after content
			$this->output = str_replace(
					template::$template_variable_beginning_char . $variable . template::$template_variable_ending_char, 
					$content . $key, 
					$this->output
				);
		}
		// if key is already in temp_variables, replace key with content + key again
		else
		{
			$this->output = str_replace(
					$this->variable_hashes[$variable], 
					$content . $this->variable_hashes[$variable], 
					$this->output
				);
		}
	}

    /**
     * Inserts the content of an plugin.
     *
     * @param string            $variable  The variable name of the plugin.
     * @param string|template   $content   The content to insert.
     */
	private function pluginInsert($variable, $content)
	{
        if($content instanceof template)
            $content = $content->getOutput();
        
		$this->output = str_replace(template::$plugin_variable_beginning_char . $variable . template::$plugin_variable_ending_char, $content, $this->output);
	}

    /**
     * Creates a valid html output of the current temporary output content.
     *
     * @return string
     * @since Version 1.0
     */
	public function getOutput()
	{
		$str = $this->output;

		// remove temp_variables
		foreach($this->variable_hashes as $key => $value)
		{
			$str = str_replace($value, "", $str);
		}

		// escape html characters which are marked		
		$pattern = "/\§\{.*\}\§/s";
		$matches = array();
		preg_match_all($pattern, $str, $matches);
		if(count($matches) < 1) return;	// if no plugin has to be loaded
		$matches = $matches[0];			// preg_match_all returns array in array
		foreach($matches as $m)
		{
			$removed = str_replace("§{", "", $m);
			$removed = str_replace("}§", "", $removed);
			$str = str_replace($m, htmlspecialchars($removed), $str);
		}
        
        if(template::$doIndent)
        {
            require_once(((strpos(BASEDIR, "/admin") !== FALSE) ? BASEDIR . "../" : BASEDIR) . "sources/dindent/Indenter.php");
            $indenter = new Gajus\Dindent\Indenter();
            $str = $indenter->indent($str);
        }

		return $str;
	}

    /**
     * Compresses the current output content.
     *
     * @return string Compress html output.
     */
	public function getCompressedOutput()
	{
        $buffer = $this->getOutput();
        
        $search = array(
            '/\>[^\S ]+/s',  // strip whitespaces after tags, except space
            '/[^\S ]+\</s',  // strip whitespaces before tags, except space
            '/(\s)+/s'       // shorten multiple whitespace sequences
        );

        $replace = array(
            '>',
            '<',
            '\\1'
        );

        $buffer = preg_replace($search, $replace, $buffer);

        return $buffer;
	}

    /**
     * Removes all unused variables.
     */
	public function removeVariables()
	{
		$pattern = "/";

		for($i = 0; $i < strlen(template::$template_variable_beginning_char); $i++)
			$pattern .= stripcslashes("\\\\" . template::$template_variable_beginning_char[$i]);

		$pattern .= ".*";

		for($i = 0; $i < strlen(template::$template_variable_ending_char); $i++)
			$pattern .= stripslashes("\\\\" . template::$template_variable_ending_char[$i]);

		$pattern .= "/";
		$this->output = preg_replace($pattern, "", $this->output);
	}

    /**
     * Disables all plugin variables and prevent their usage in future.
     */
	public function preventPlugins()
	{
		// find all plugins with regex pattern
		$pattern = "/\%\{.*\}\%/";
		$matches = array();
		preg_match_all($pattern, $this->output, $matches);
		if(count($matches) < 1) return;	// if no plugin has to be loaded
		$matches = $matches[0];			// preg_match_all returns array in array

		// enumerate matches to call plugins
		foreach($matches as $m)
		{
			$temp = substr_replace($m, "_", 1, 0);
			$this->output = str_replace($m, $temp, $this->output);
		}
	}

    /**
     * Loads all plugins by seaching plugin variables and trying to instanciate an object used
     * to call getOutput() method on it.
     */
	public function loadPlugins()
	{
		// find all plugins with regex pattern
		$pattern = "/\%\{.*\}\%/";
		$matches = array();
		preg_match_all($pattern, $this->output, $matches);
		if(count($matches) < 1) return;	// if no plugin has to be loaded
		$matches = $matches[0];			// preg_match_all returns array in array

		// enumerate matches to call plugins
		foreach($matches as $m)
		{
			// get plugin name without delimiter strings
			$plugin = str_replace(template::$plugin_variable_beginning_char, "", $m);
			$plugin = str_replace(template::$plugin_variable_ending_char, "", $plugin);
			$parameter = null;

			// split plugin name from possible parameters
			if(strpos($plugin, ":") !== false)
			{
				$parameter = explode(":", $plugin)[1];
				$plugin = explode(":", $plugin)[0];
			}

			// used later for insertion
			$pluginstring = $plugin . ($parameter != null ? ":" . $parameter : "");

			// check if requested plugin file exists
			if(!file_exists("plugins/" . $plugin . "/" . $plugin . ".php"))
			{
				$this->pluginInsert($pluginstring, "Die Datei '" . $plugin . "/" . $plugin . ".php' wurde nicht gefunden");
				continue;
			}

			// class is not defined in file
			include_once("plugins/" . $plugin . "/" . $plugin . ".php");
			if(!class_exists($plugin))
			{
				$this->pluginInsert($pluginstring, "Die Plugin-Klasse wurde nicht definiert.");
				continue;
			}

			// create instance
			$obj = new $plugin();

			// class does not implement imodule interface
			if(!($obj instanceof iplugin))
			{
				$this->pluginInsert($pluginstring, "Die Modul-Klasse hat das imodule-Interface nicht implementiert.");
				continue;
			}

			try
			{
				// call getOutput() method and insert into index template
				$this->pluginInsert($pluginstring, $obj->getOutput($parameter));
			}
			catch(Exception $ex)
			{
				$this->pluginInsert($plugin, $ex->getMessage());
			}
		}
	}

    /**
     * Loads all static contents from files and inserts them.
     */
    public function loadStaticContent()
    {
        // find all plugins with regex pattern
        $pattern = "/s\{.*\}s/";
        $matches = array();
        preg_match_all($pattern, $this->output, $matches);
        if(count($matches) < 1) return;	// if no plugin has to be loaded
        $matches = $matches[0];			// preg_match_all returns array in array

        // enumerate matches to call plugins
        foreach($matches as $m)
        {
            $m2 = str_replace("s{", "", $m);
            $m2 = str_replace("}s", "", $m2);
            $filename = template::$template_constants["static_dir"] . $m2 . ".html";
            if(!file_exists($filename))
            {
                $this->output = str_replace(
                    $m, 
                    "Datei " . $filename . " nicht gefunden",
                    $this->output);
            }
            else
            {
                $this->output = str_replace($m, file_get_contents($filename), $this->output);
            }
        }
    }

    /**
     * Creates a new template and directly fills in the given values.
     *
     * <code>
     * template::create("index", array(
     *      "var1" => "hello world"
     * ));
     * </code>
     *
     * @param string    $template   Name of the template.
     * @param array     $content    Content for the variables.
     * @static
     * @since Version 1.7
     */
    public static function create($template, $content)
    {
        $tpl = new template($template);
        
        foreach($content as $key => $value) 
        {
            $tpl->insert($key, $value);
        }
        
        return $tpl->getOutput();
    }
}


?>