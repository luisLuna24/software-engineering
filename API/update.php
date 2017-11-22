<?php
require('connection.php');

$rows = array();

$conn = new mysqli($host, $dbuser, $dbpass, $dbName);
if ($conn->connect_error) {
	//REGRESA ERROR DE NO CONEXION
    die("Connection failed: " . $conn->connect_error);
	
}


/*post expected : post[0] : id ; post[1] : field updated ; post[2] : new value ; in case of password post[3] : old password.
Fields accepted : Contrasena, Email, Imagen, Altura, Peso
others will be rejected.
In the case of password changes, the old password will be checked.


*/


$id = $_POST['id'];
$field = $_POST['field'];
$new_value = $_POST['new_value'];
$old_password = $_POST['old_pw'];


//possible type issues due to no quote in the where condition
//$already_known = mysql_query('SELECT * FROM USUARIO WHERE Usuario=$usr or Id=$id');
 
switch($field) {
  case "Contrasena":
  case "Email":
  case "Imagen":
  case "Altura":
  case "Peso":
    $validField = 1;
    break;
  default: $validField = 0;
} 


if ($validField) {
  if($field == "Contrasena") {
    $valid_old_password = mysql_query('SELECT * FROM USUARIO WHERE Id=$id and Contrasena=$old_password');
    
    if(mysql_num_rows($valid_old_password) == 0) {
      die('Wrong old password' . mysql_error());
    }
  }



	$sql = "UPDATE USUARIO SET $field=$new_value WHERE Id=$id";

	if ($conn->query($sql) === TRUE) {
	    echo "$field successfully updated to $new_value";
	} else {
	    echo "Error: " . $sql . "<br>" . $conn->error;
	}

	$conn->close();
} else {
    die('$field is not a valid field to modify. ' . mysql_error());
}

$conn->close();
?>
