<?php
require('connection.php');

$rows = array();

$conn = new mysqli($host, $dbuser, $dbpass, $dbName);
if ($conn->connect_error) {
	//REGRESA ERROR DE NO CONEXION
    die("Connection failed: " . $conn->connect_error);
	
}


/*
$usr = $_POST['Usuario'];
$id = $_POST['Id'];
$pw = $_POST['Contrasena'];
$email = $_POST['Email'];
$name = $_POST['Nombre'];
$birth_date = $_POST['Nacimiento'];
$sexo = $_POST['Sexo'];
$image = $_POST['Imagen'];
$blood_type = $_POST['Sangre'];
$height = $_POST['Altura'];
$weight = $_POST['Peso'];
*/
$id = $_POST[0];
$usr = $_POST[1];
$pw = $_POST[2];
$email = $_POST[3];
$name = $_POST[4];
$birth_date = $_POST[5];
$sexo = $_POST[6];
$image = $_POST[7];
$blood_type = $_POST[8];
$height = $_POST[9];
$weight = $_POST[10];


//possible type issues due to no quote in the where condition
$already_known = mysql_query('SELECT * FROM USUARIO WHERE Usuario=$usr or Id=$id');
 
 

if (mysql_num_rows($already_known) == 0) {
	$sql = "INSERT INTO USUARIO (Id, Usuario, Contrasena, Email, Padecimientos, Nombre, Nacimiento, Sexo, Imagen, Medicamento, Sangre, Altura, Peso) VALUES
	($id, '$usr', '$pw', '$email', NULL, '$name', '$birth_date', '$sexo', '$image', '', '$blood_type', $height, $weight)";

	if ($conn->query($sql) === TRUE) {
	    echo "New account created successfully";
	} else {
	    echo "Error: " . $sql . "<br>" . $conn->error;
	}

	$conn->close();
} else {
    die('Id or User already exists : ' . mysql_error());
}

$conn->close();
?>
