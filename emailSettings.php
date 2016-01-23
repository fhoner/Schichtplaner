<?php

/**
 * Simple enum class that indicates the email send type. 
 */
abstract class emailSendMethod
{
    const PHPMAILER = 0;
    const MAIL = 1;
}

/**
 * The email class providing sending functions.
 *
 * @author Felix Honer
 * @abstract
 * @version 1.1
 */
abstract class emailSettings
{
    /**
     * The hostname of the smtp server.
     *
     * @var string $host
     * @static
     */
    private static $host;

    /**
     * Username used to authenticate on smtp server.
     *
     * @var string $username
     * @static
     */
	private static $username;

    /**
     * Password used to authenticate on smtp server.
     *
     * @var string $password
     * @static
     */
	private static $password;

    /**
     * Sender which will be used at any email sent by this class.
     *
     * @var string $sender
     * @static
     */
	private static $sender;

    /**
     * The sending method which will be used.
     *
     * @var emailSendMethod $method
     * @static
     */
    private static $method;
    
    /**
     * SMTP Port.
     *
     * @var int $port
     * @static
     */
	private static $port = 587;

    /**
     * Using protocol.
     *
     * @var string $smtpSecure
     * @static
     */
	private static $smtpSecure = 'tls';

    /**
     * Value that indicates if authentication on server is required.
     *
     * @var bool $smtpAuth
     * @static
     */
	private static $smtpAuth = true;
    
    
    /**
     * Setter of the host field.
     *
     * @param string $val
     * @static
     */
    public static function setHost($val) 
    { 
        emailSettings::$host = $val; 
    }
    
    /**
     * Getter of the host field.
     *
     * @return string
     * @static
     */
    public static function getHost() 
    {
        return emailSettings::$host; 
    }
    
    /**
     * Setter of the username field.
     *
     * @param string $val
     * @static
     */
    public static function getUsername() 
    { 
        return emailSettings::$username; 
    }
    
    /**
     * Getter of the username field.
     *
     * @return string
     * @static
     */
    public static function setUsername($val) 
    { 
        emailSettings::$username = $val; 
    }
    
    /**
     * Setter of the password field.
     *
     * @param string $val
     * @static
     */
    public static function getPassword() 
    { 
        return emailSettings::$password; 
    }
    
    /**
     * Getter of the password field.
     *
     * @return string
     * @static
     */
    public static function setPassword($val) 
    { 
        emailSettings::$password = $val; 
    }
    
    /**
     * Setter of the sender field.
     *
     * @param string $val
     * @static
     */
    public static function getSender() 
    { 
        return emailSettings::$sender; 
    }
    
    /**
     * Getter of the sender field.
     *
     * @return string
     * @static
     */
    public static function setSender($val) 
    { 
        emailSettings::$sender = $val; 
    }
    
    /**
     * Setter of the method field.
     *
     * @param string $val
     * @static
     */
    public static function getMethod() 
    { 
        return emailSettings::$method; 
    }
    
    /**
     * Getter of the host field.
     *
     * @return emailSendMethod
     * @static
     */
    public static function setMethod($val) 
    { 
        emailSettings::$method = $val; 
    }
    
    /**
     * Main function to send a email to one or more recipients.
     *
     * @param string/array  $recipients Recipients the email will be sent to.
     * @param string        $subject    The subject of the email.
     * @param string        $body       Content of the email.
     * @param string        $error      Get the error message via call by reference.
     *
     * @return bool Value either the email was sent successfully or not.
     * @static
     */
    public static function send($recipients, $subject, $body, &$error = null)
    {
        if(emailSettings::$method == emailSendMethod::PHPMAILER)
        {
            if (strpos(ROOT, 'admin') !== FALSE)
                require_once(BASEDIR . "../sources/phpmailer/PHPMailerAutoload.php");
            else
                require_once(BASEDIR . "sources/phpmailer/PHPMailerAutoload.php");
 
			
			
            $mail = new PHPMailer(true);
            $mail->IsHTML(true);
            $mail->CharSet = 'UTF-8';
            $mail->IsSMTP();
            //$mail->SMTPDebug = 2;
            $mail->SMTPDebug = 0;
            $mail->Debugoutput = 'html';
            $mail->Host = emailSettings::$host;
            $mail->Port = emailSettings::$port;
            $mail->SMTPSecure = emailSettings::$smtpSecure;
            $mail->SMTPAuth = emailSettings::$smtpAuth;
            $mail->Username = emailSettings::$username;
            $mail->Password = emailSettings::$password;
            $mail->setFrom(emailSettings::$sender);
            $mail->FromName = ORGANISATION;
            
            if(!is_array($recipients))
              $mail->AddBCC($recipients);
            else
            {
                foreach($recipients as $rec)
                {
                    $mail->AddBCC($rec);
                }
            }

            $mail->Subject = trim($subject);
            $mail->msgHTML(trim($body));

            try
            {
                $mail->Send();
            }
            catch(Exception $ex)
            {
                $error = $ex->errorMessage();
                return false;
            }

            return true;
        }
        
        if(emailSettings::$method == emailSendMethod::MAIL)
        {
            $header = "";

            // create header
            $header .= 'MIME-Version: 1.0' . "\r\n";
            $header .= 'Content-type: text/html; charset=UTF-8' . "\r\n";
            $header .= "From: " . ORGANISATION . "<" . emailSettings::$sender . ">\r\n";
            $header .= "Reply-To: " . ORGANISATION . " <" . emailSettings::$sender . ">";
            
            if(is_array($recipients))
            {
                foreach($recipients as $rec)
                    mail($rec, $subject, $body, $header);
            }
            else
                mail($recipients, $subject, $body, $header);

            return true;
        }
    }
}

?>