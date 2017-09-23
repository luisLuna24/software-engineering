$result = mysql_query("SELECT ...");
$rows = array();

while($r = mysql_fetch_assoc($result)) {
	$rows['object_name'][] = $r;
}

 print json_encode($rows);