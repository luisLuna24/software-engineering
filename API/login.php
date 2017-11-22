<?php
require('connection.php');

$user = $_GET['user'];
$pass = $_GET['pass'];
$rows = array();

$conn = new mysqli($host, $dbuser, $dbpass, $dbName);
if ($conn->connect_error) {
	//REGRESA ERROR DE NO CONEXION
	$rows['conexionError'] = 'true';
	
}






$sql = "SELECT * FROM USUARIO WHERE Usuario = '$user' && Contrasena = '$pass'";

$result = $conn->query($sql) or die($conn->error);
					


if ($row = $result->fetch_assoc()) {
	
	$rows = $row;
	$rows['loginError'] = 'false';
	$rows = array_map('utf8_encode', $rows);
	//print (json_encode($rows));
} else {
	$rows['loginError'] = 'true';
	
	
}
print (json_encode($rows));



//Recibe Usuario y Contraseña, consulta la BD. Si es correcto envia JSON de toda la Tabla Usuario y sus relaciones.
//En caso de estar mal el login regresa un mensaje de error con: Tipo, Descripcion, Codigo de Error = 1

?>

