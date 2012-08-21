<?php

include "./config/config.php";

$file = file_get_contents('./create.sql', true);
$separator = "--\r\n--\r\n--";

$connection = mysql_pconnect($MYSQL_DB_HOST . ":" . $MYSQL_DB_PORT, $MYSQL_DB_USER, $MYSQL_DB_PASS);
if ( !mysql_ping($connection) ) {
	$connection = mysql_pconnect($MYSQL_DB_HOST . ":" . $MYSQL_DB_PORT, $MYSQL_DB_USER, $MYSQL_DB_PASS);
}
$db_select = mysql_select_db($MYSQL_DB_NAME, $connection);

if ($connection == FALSE) {
	$content = "";
	$content .= "Could not connect to the MqSql server: [" . $MYSQL_DB_HOST . ":" . $MYSQL_DB_PORT . "@" . $MYSQL_DB_USER . "].";
	$content .= "<br />";
	$content .= "Please review your settings in the 'config.php'.";
	$content .= "<br />";
	
	echo $content;
	exit();
} else if ($db_select == FALSE) {
	$content = "";
	$content .= "Could not select MySql database: " . $MYSQL_DB_NAME . ".";
	$content .= "<br />";
	$content .= "Please review your settings in the 'config.php' and/or check your database.";
	$content .= "<br />";
	
	echo $content;
	exit();
} else if ( $file == FALSE ) {
	$content = "";
	$content .= "File 'create.sql' does not exists or cannot be read.";
	$content .= "<br />";
	
	echo $content;
	exit();
}

$content = "";
$queries = explode($separator, $file);
for ( $i = 0; $i < count($queries); $i++ ) {
	$q = $queries[$i];
	
	$content .= "Executing query: " . $q;
	$content .= "<br />";
	
	$res = mysql_query($q, $connection);
	if ( $res == FALSE ) {
		$content .= "Query is invalid or cannot be executed: " . mysql_error($connection);
		$content .= "<br />";
	} else {
		$content .= "Query executed successfully.";
		$content .= "<br />";
	}
}

$content .= "Installation script ended.";
$content .= "<br />";
$content .= "Please recheck your database and remove 'install.php' and 'create.sql' files in case of a successful commit.";
$content .= "<br />";


echo $content;
exit();

?>
