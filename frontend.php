<?php

/**
 * This class provides several functions which can be used by modules, plugins etc.
 *
 * @author Felix Honer
 * @version 1.1 (2015-12-03)
 * @abstract
 */
abstract class frontend
{
    /**
     * Logger instances.
     *
     * @var array $logger
     * @since Version 1.1
     * @static
     */
    private static $logger;
    
    /**
     * Gets the singleton logger instance.
     *
     * @param $name String Name of the target log file.
     * @return Logger The logger instance.
     * @static
     */
    public static function getLogger($name = "")
    {
        if($name == "")
            $name = "main";
        
        if(frontend::$logger == null)
        {            
            // set up logger array
            frontend::$logger = array();
        }
        
        if(!isset(frontend::$logger[$name])) // logger does not exist yet
        {    
            $admin = false;
            $filename = "";
            
            // create new instance and add to array
            if(file_exists(BASEDIR . "core/log4php/Logger.php"))
            {
                $filename = BASEDIR . "core/log4php/Logger.php";
                include_once($filename);
            }
            else if(file_exists(BASEDIR . "../core/log4php/Logger.php"))
            {
                $filename = BASEDIR . "../core/log4php/Logger.php";
                include_once($filename);
                $admin = true;
            }
            else
                throw new Exception("Logger could not be loaded. File not found");
            
            // check if config file has to be created, either because it does not exist
            // or the template file is newer than the existing one.
            $templatefile = BASEDIR . ($admin ? "../" : "") . "files/static/log4php/config-template.xml";
            $logfile = $admin == true ? BASEDIR . "../files/static/log4php/adminconfig.xml" :
                                        BASEDIR .    "files/static/log4php/config.xml";
            
            if(!file_exists($logfile) 
               || filectime($logfile) < filectime($templatefile)
               || strpos(file_get_contents($logfile), $templatefile) !== true)
            {
                $xml = file_get_contents($templatefile);
                $xml = str_replace('{{path}}', BASEDIR, $xml);
                file_put_contents($logfile, $xml);
            }
            
            Logger::configure($logfile);            
            frontend::$logger[$name] = Logger::getLogger($name == "" ? "log" : $name);
        }        

        return frontend::$logger[$name];
    }
    
    /**
     * Checks if a link is represented as a destination link in navigation bar.
     *
     * @param   string $destination The href to check.
     * @return  bool Value if the navigation contains the given href.
     * @static
     * @since   Version 1.0
     */
    public static function isInNavigation($destination)
    {
        $result = dbConn::querySingle("SELECT COUNT(*) FROM :prefix:navigation WHERE destination = :0", $destination) > 0;
        frontend::getLogger()->debug("check if link ist as destination in navigation for '" . destination . 
                                    "' with result: " . $result);
        return $result;
    }
    
    /**
     * Returns short class without namespace prefix of an object.
     *
     * @param object $object 
     * @return string Class name without namespace.
     * @static
     * @since Version 1.0
     */
    public static function getShortClassName($object)
    {
        $reflection = new ReflectionClass($this);
        return $reflection->getShortName();
    }
    
    /**
     * Loads all (unloaded) frontend modules and returns an array with all loaded module names.
     *
     * @return array Names of all modules which were loaded.
     * @static
     * @since Version 1.0
     */
    public static function loadAllModules()
    {
        frontend::getLogger()->debug("trying to load all installed modules");
        
        $modules = array();
        foreach(dbConn::query("SELECT class FROM :prefix:module WHERE backendOnly = 0") as $r)
        {
            if(!file_exists(BASEDIR . "modules/" . $r['class'] . "/" . $r['class'] . ".php"))
            {
                frontend::getLogger()->error("module could not be loaded because file does not exist: " . 
                                            BASEDIR . "modules/" . $r['class'] . "/" . $r['class'] . ".php");
                throw new Exception("Failed while loading installed module as the module file was not found: " . 
                                    BASEDIR . "modules/" . $r['class'] . "/" . $r['class'] . ".php");
            }
            
            require_once(BASEDIR . "modules/" . $r['class'] . "/" . $r['class'] . ".php");
            array_push($modules, "\\frontend\\" . $r['class']);
        }
        
        frontend::getLogger()->debug("following modules loaded successfully: " . implode(",", $modules));
        return $modules;
    }
    
    /**
     * Generates sitemap by all modules that implement isitemap interface.
     *
     * @return array All sitemap entries.
     * @static
     * @since Version 1.0
     */
    public static function generateSitemap()
    {
        $modules = frontend::loadAllModules();
        $data = array();
        
        foreach($modules as $m)
        {
            $obj = new $m();
            if($obj instanceof \frontend\isitemap)
            {
                $map = $obj->getSitemap();
                
                if(isset($map['loc']))
                    array_push($data, $map);
                else
                {
                    foreach($map as $link)
                        array_push($data, $link);                        
                }
            }
        }
        
        return $data;
    }
    
    /**
     * Makes html output to support zoomable images (click to fullscreen).
     * note: Dont give complete html document as parameter. Only give the 
     * element inside of the body.
     *
     * @param   string $html The html content that contains the images.
     * @return  string The html content with integrated image zoom.
     * @static
     * @since Version 1.0
     */
    public static function addZoomGallery($html)
    {
        preg_match_all('/<img[^>]+>/i', $html, $matches);
        if (isset($matches[0])) 
        {
            $c = 0;
            foreach($matches[0] as $link) 
            {
                // set title attribute
                $xpath = new DOMXPath(@DOMDocument::loadHTML($link));
                $src = $xpath->evaluate("string(//img/@src)");  // get src
                $imgTitle = explode("/", $src); // split by slashes
                $imgTitle = end($imgTitle); // use last element of array
                $imgTitle = explode(".", $imgTitle)[0]; // remove file extension
                
                $dom = @DOMDocument::loadHTML($link, LIBXML_HTML_NOIMPLIED | LIBXML_HTML_NODEFDTD); // prevent <html><body> tags in output
                $xpath = new DOMXPath($dom);
                $title = $xpath->evaluate("//img");
                $title->item(0)->setAttribute("title", $imgTitle);
                $image = $dom->saveHTML();
                
                
                $html = str_replace(
                    $link,
                    "<a href=\"$src\" data-source=\"$src\" title=\"$imgTitle\" alt=\"$imgTitle\" class=\"img-zoom\">" . $image . "</a>",
                    $html
                );
                $c++;
            }
        }
        
        return "<div class=\"zoom-gallery\">$html</div>";
    }

    /**
     * Minimies js code to the minimum.
     *
     * @param string js code before minimizing as string
     * @return string minified js code as string
     * @static
     * @since Version 1.0
     */
    public static function minifyJs($js)
    {
        $lib = BASEDIR . "sources/minifier/Minifier.php";

        if(!file_exists($lib))
            throw new Exception("Minifier library could not be loaded (" . $lib . ").");
        
        require_once(BASEDIR . "sources/minifier/Minifier.php");
        return \JShrink\Minifier::minify($js);
    }
    
    
}

?>