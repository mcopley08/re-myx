<?php

function IsInjected($str)
{
    $injections = array('(\n+)',
           '(\r+)',
           '(\t+)',
           '(%0A+)',
           '(%0D+)',
           '(%08+)',
           '(%09+)'
           );
                
    $inject = join('|', $injections);
    $inject = "/$inject/i";
     
    if(preg_match($inject,$str))
    {
      return true;
    }
    else
    {
      return false;
    }
}



if (isset($_post['submit']))
{
	echo "error, you need to submit the form!";
}

$name = $_POST['name'];
$visitor_email = $_POST['email'];
$message = $_POST['message'];

// error checking
if(IsInjected($visitor_email) || IsInjected($message) || IsInjected($name))
{
    echo "Bad email value!";
    exit;
}

if (empty($name) || empty($visitor_email)) {
	echo "Name and email are mandatory!";
	exit;
}

$email_from = 'mdcopley@umich.edu';
$email_subject = 'Re-Myx Inquiry';
$email_body = "heyyyyy, you have received a message from $name.\n".
	"email address: $visitor_email\n".
	"Here is the message\n $message";

$to = "mdcopley@umich.edu";
$headers = "From: $email_from \r\n";

mail($to,$email_subject,$email_body,$headers);

?>