<?php
require('connection.php');

$user = $_GET['user'];

$rows = array();

$conn = new mysqli($host, $dbuser, $dbpass, $dbName);
if ($conn->connect_error) {
	//REGRESA ERROR DE NO CONEXION
	$rows['conexionError'] = 'true';
	
}




$sql = "SELECT * FROM MEDICAMENTO WHERE Usuario = '$user'";

$result = $conn->query($sql) or die($conn->error);
					


while ($row = $result->fetch_assoc()) {
	
	$rows = $row;
	$rows = array_map('utf8_encode', $rows);
	print (json_encode($rows));
	//print (json_encode($rows));
}/* else {
	$rows['noMeds'] = 'true';
}*/




//Recibe Usuario y Contraseña, consulta la BD. Si es correcto envia JSON de toda la Tabla Usuario y sus relaciones.
//En caso de estar mal el login regresa un mensaje de error con: Tipo, Descripcion, Codigo de Error = 1

?>

