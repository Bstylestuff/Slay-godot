<?php
/* Database credentials. Assuming you are running MySQL
server with default setting (user 'root' with no password) */
define('DB_SERVER', 'sql310.epizy.com');
define('DB_USERNAME', 'epiz_24847047');
define('DB_PASSWORD', 'PdRKihFxBd3p');
define('DB_NAME', 'epiz_24847047_Gravity_servers');
 
/* Attempt to connect to MySQL database */
$mysqli = new mysqli(DB_SERVER, DB_USERNAME, DB_PASSWORD, DB_NAME);
 
// Check connection
if($mysqli === false){
    die("ERROR: Could not connect. " . $mysqli->connect_error);
}

function dbconnect()
  {

    // Create connection
    $conn = new mysqli(DB_SERVER, DB_USERNAME, DB_PASSWORD, DB_NAME);
    // Check connection
      if ($conn->connect_error) {
	echo "ERROR M8";
          die("Connection failed: " . $conn->connect_error);
      }
    return $conn;
  }
?>


