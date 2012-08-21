<?php

include "../config/config.php";
include "./common.php";


define(PROP_RESULT,				"result");
define(PROP_ACTION,				"action");
define(PROP_SUCCESS,			"success");
define(PROP_ERROR,				"error");
define(PROP_PARTNER,			"partner");
define(PROP_LIST,				"list");
define(PROP_USER,				"user");
define(PROP_ID,					"id");
define(PROP_STATUS,				"status");
define(PROP_DISABLED,			"disabled");
define(PROP_REPORTER_DISABLED,	"reporterdisabled");
define(NEW_LINE,				"\n");

define(GET_CODE,		"code");
define(GET_ACTION,		"action");
define(GET_USERNAME,	"username");
define(GET_ID,			"id");
define(GET_PARTNER,		"partner");
define(GET_STATUS,		"status");

define(ACTION_TYPE_REGISTER,	"register");
define(ACTION_TYPE_UNREGISTER,	"unregister");
define(ACTION_TYPE_LOOKUP,		"lookup");

define(ACTION_TYPE_LIST,		"list");

define(ACTION_TYPE_PING,		"ping");
define(ACTION_TYPE_FIND,		"find");
define(ACTION_TYPE_REPORT,		"report");


define(STATUS_WAITING,		"WAITING");
define(STATUS_CONNECTING,	"CONNECTING");
define(STATUS_CONNECTED,	"CONNECTED");



$code = 		$_GET[GET_CODE];
$action = 		$_GET[GET_ACTION];
$user_name = 	$_GET[GET_USERNAME];
$id = 			$_GET[GET_ID];
$partner = 		$_GET[GET_PARTNER];
$status = 		$_GET[GET_STATUS];



/**
 * Removes all phantom registrations.
 */
function remove_all_phantom_users($connection) {
	global $VALID_INTERVAL;
	
	$q = "
		DELETE FROM `registrations`
		WHERE `updatetime` <= DATE_ADD(NOW(), INTERVAL -" . $VALID_INTERVAL . " SECOND)
	";
	mysql_query($q, $connection);
}
/**
 * Registers or updates the given user. All the timeouted registrations will be cleared to maintain a clean database.
 */
function register_user($connection, $user_name, $id, $partner, $status) {
	$q = "
		SELECT `username`
		FROM `registrations`
		WHERE `username` = '" . $user_name . "'
	";
	$check = mysql_query($q, $connection);
	$partner_sql = empty($partner) ? "NULL" : "'" . $partner . "'";

	if (mysql_num_rows($check) == 1) {
		$q = "
			UPDATE `registrations`
			SET
				`id` = '" . $id . "',
				`updatetime` = NOW(),
				`partner` = " . $partner_sql . ",
				`status` = '" . $status . "',
				`ip` = '" . getIp() . "'
			WHERE `username` = '" . $user_name . "'
		";
	} else {
		$q = "
			INSERT INTO `registrations` (`username`, `id`, `updatetime`, `partner`, `status`, `ip`)
			VALUES ('" . $user_name . "', '" . $id . "', NOW(), " . $partner_sql . ", '" . $status . "', '" . getIp() . "')
		";
	}
	mysql_query($q, $connection);
}
/*
 * Returns the id of the current user.
 */

function get_user_if_valid($connection, $user_name) {
	global $VALID_INTERVAL;
	
	//$q = "
	//	SELECT `username`, `id`
	//	FROM `registrations`
	//	WHERE
	//		`username` = '" . $user_name . "' AND
	//		`updatetime` > DATE_ADD(NOW(), INTERVAL -" . $VALID_INTERVAL . " SECOND)
	//";
	
	$q = "
		SELECT `username`, `id`
		FROM `registrations`
		WHERE `username` = '" . $user_name . "'
	";
	$res = mysql_query($q, $connection);
	$row = mysql_fetch_array($res);
	return $row;
}

/**
 * Return an array of valid users and its connected parteners, different than the requesting one.
 */

function get_all_valid_users($connection, $user_name) {
	global $VALID_INTERVAL;
	
	$q = "
		SELECT `username`, `partner`
		FROM `registrations`
		WHERE
			`username` <> '" . $user_name . "' AND
			`updatetime` > DATE_ADD(NOW(), INTERVAL -" . $VALID_INTERVAL . " SECOND)
		ORDER BY `username` ASC
	";
	$res = mysql_query($q, $connection);
	$array = array();
	while ( $row = mysql_fetch_array($res) ) {
		array_push($array, $row);
	}
	return $array;
}

function get_first_user_without_partner($connection, $user_name) {
	global $VALID_INTERVAL;
	
	$q = "
		SELECT `username`, `id`
		FROM `registrations`
		WHERE
			`username` <> '" . $user_name . "' AND
			`updatetime` > DATE_ADD(NOW(), INTERVAL -" . $VALID_INTERVAL . " SECOND) AND
			`partner` is NULL
		LIMIT 0, 1
	";
	$res = mysql_query($q, $connection);
	$row = mysql_fetch_array($res);
	return $row;
}


function detect_abuse($connection, $username, $ip) {
	global $REPORTS_MAX_ALLOWED_PER_DAY;
	global $REPORTS_ABUSE_DETECTION_STRATEGY;
	
	$num_reports = 0;
	if ( $REPORTS_ABUSE_DETECTION_STRATEGY == "IP" ) {
		$q = "
			SELECT count(*) as num_reports FROM `reports`
			WHERE
				`userip` = '" . $ip . "' AND
				DATE(`timestamp`) = DATE(NOW())
		";
		$res = mysql_query($q, $connection);
		$row = mysql_fetch_array($res);
		$num_reports = $row['num_reports'];
	} else if ( $REPORTS_ABUSE_DETECTION_STRATEGY == "USER" ) {
		$username_array = xmlstr_to_array("<xml>" . $username . "</xml>");
		unset($username_array['random']);
		$username_part = generate_xml_from_array($username_array);
		
		$q = "
			SELECT count(*) as num_reports FROM `reports`
			WHERE
				`username` LIKE '%" . $username_part . "%' AND
				DATE(`timestamp`) = DATE(NOW())
		";
		$res = mysql_query($q, $connection);
		$row = mysql_fetch_array($res);
		$num_reports = $row['num_reports'];
	}
	
	if ( $num_reports >= $REPORTS_MAX_ALLOWED_PER_DAY ) {
		return true;
	} else {
		return false;
	}
}

function get_random_user_without_partner($connection, $user_name) {
	global $VALID_INTERVAL;
	
	$q = "
		SELECT `username`, `id`, `status`, `ip`
		FROM `registrations`
		WHERE
			`username` <> '" . $user_name . "' AND
			`updatetime` > DATE_ADD(NOW(), INTERVAL -" . $VALID_INTERVAL . " SECOND) AND
			(
				(`partner` is NULL AND `status` = '" . STATUS_WAITING . "') OR
				(`partner` = '" . $user_name . "' AND `status` = '" . STATUS_CONNECTING . "')
			)
	";
	$res = mysql_query($q, $connection);
	
	$array = array();
	while ( $row = mysql_fetch_array($res) ) {
		array_push($array, $row);
	}
	$ret = $array[array_rand($array)];
	
	if ( $ret ) {
		$q = "
			SELECT `ip`
			FROM `registrations`
			WHERE `username` = '" . $user_name . "'
		";
		$res = mysql_query($q, $connection);
		$row = mysql_fetch_array($res);
		$user_ip = $row['ip'];
		
		$disabled = detect_abuse($connection, $ret['username'], $ret['ip']);
		$reporter_disabled = detect_abuse($connection, $user_name, $user_ip);
		
		if ( $ret['status'] == STATUS_WAITING ) {
			$status = STATUS_CONNECTING;
		} else {
			$status = STATUS_WAITING;
		}
		
		$q = "
			UPDATE `registrations`
			SET
				`updatetime` = NOW(),
				`partner` = '" . $ret['username'] . "',
				`status` = '" . $status . "'
			WHERE `username` = '" . $user_name . "'
		";
		mysql_query($q, $connection);
		
		$ret['status'] = $status;
		$ret['disabled'] = $disabled ? "true" : "false";
		$ret['reporterdisabled'] = $reporter_disabled ? "true" : "false";
	} else {
		$q = "
			UPDATE `registrations`
			SET
				`updatetime` = NOW(),
				`partner` = NULL,
				`status` = '" . STATUS_WAITING . "'
			WHERE `username` = '" . $user_name . "'
		";
		mysql_query($q, $connection);
	}
	return $ret;
}

function report($connection, $user_name, $reporter_user_name) {
	$q = "
		SELECT `ip`
		FROM `registrations`
		WHERE `username` = '" . $user_name . "'
	";
	$res = mysql_query($q, $connection);
	$row = mysql_fetch_array($res);
	$user_ip = $row['ip'];
	
	$q = "
		SELECT `ip`
		FROM `registrations`
		WHERE `username` = '" . $reporter_user_name . "'
	";
	$res = mysql_query($q, $connection);
	$row = mysql_fetch_array($res);
	$reporter_user_ip = $row['ip'];
	
	$q = "
		INSERT INTO `reports` (`userip`, `reporteruserip`, `timestamp`, `username`, `reporterusername`)
		VALUES ('" . $user_ip . "', '" . $reporter_user_ip . "', NOW(), '" . $user_name . "', '" . $reporter_user_name . "')
	";
	mysql_query($q, $connection);
}


$res = "";
$res .= "<?xml version='1.0' encoding='utf-8'?>" . NEW_LINE;
$res .= "<" . PROP_RESULT . ">" . NEW_LINE;
$res .= "\t<" . PROP_ACTION . ">" . $action . "</" . PROP_ACTION . ">" . NEW_LINE;

try {
	if ( startsWith($code, $VALIDATION_CODE) == false ) {
		throw new Exception("Invalid validation code: " . $code);
	}
	
	$connection = mysql_pconnect($MYSQL_DB_HOST . ":" . $MYSQL_DB_PORT, $MYSQL_DB_USER, $MYSQL_DB_PASS);
	if ( !mysql_ping($connection) ) {
		$connection = mysql_pconnect($MYSQL_DB_HOST . ":" . $MYSQL_DB_PORT, $MYSQL_DB_USER, $MYSQL_DB_PASS);
	}
	$db_select = mysql_select_db($MYSQL_DB_NAME, $connection);
	
	if ($connection == FALSE) {
		$res .= "\t<" . PROP_ERROR . ">Cannot connect to database server [" . $MYSQL_DB_HOST . ":" . $MYSQL_DB_PORT . "@" . $MYSQL_DB_USER . "]</" . PROP_ERROR . ">" . NEW_LINE;
		throw new Exception("Could not connect to the MqSql server: [" . $MYSQL_DB_HOST . ":" . $MYSQL_DB_PORT . "@" . $MYSQL_DB_USER . "]");
	} else if ($db_select == FALSE) {
		$res .= "\t<" . PROP_ERROR . ">Cannot use the given [" . $MYSQL_DB_NAME . "] database</" . PROP_ERROR . ">" . NEW_LINE;
		throw new Exception("Could not select MySql database: " . $MYSQL_DB_NAME);
	}
	
	remove_all_phantom_users($connection);
	
	if ($action == ACTION_TYPE_REGISTER) {
		register_user($connection, $user_name, $id, null, STATUS_WAITING);
	}
	else if ($action == ACTION_TYPE_UNREGISTER) {
		register_user($connection, $user_name, "0", null, STATUS_WAITING);
	}
	
	else if ($action == ACTION_TYPE_LOOKUP) {
		if ( !empty($partner) ) {
			$array_partner = get_user_if_valid($connection, $partner);
			if ( $array_partner ) {
				$res .= "\t<" . PROP_PARTNER . ">" . NEW_LINE;
				$res .= "\t\t<" . PROP_USER . ">" . $array_partner['username'] . "</" . PROP_USER . ">" . NEW_LINE;
				$res .= "\t\t<" . PROP_ID . ">" . $array_partner['id'] . "</" . PROP_ID . ">" . NEW_LINE;
				$res .= "\t</" . PROP_PARTNER . ">" . NEW_LINE;
			}
		} else {
			$res .= "\t<" . PROP_ERROR . ">Partner could not be empty</" . PROP_ERROR . ">" . NEW_LINE;
			throw new Exception("Empty partner");
		}
	}
	
	else if ($action == ACTION_TYPE_PING) {
		register_user($connection, $user_name, $id, $partner, $status);
	}
	
	else if ($action == ACTION_TYPE_LIST) {
		$array_users = get_all_valid_users($connection, $user_name);
		foreach ( $array_users as $user ) {
			$res .= "\t<" . PROP_LIST . ">" . NEW_LINE;
			$res .= "\t\t<" . PROP_USER . ">" . $user['username'] . "</" . PROP_USER . ">" . NEW_LINE;
			$res .= "\t\t<" . PROP_PARTNER . ">" . $user['partner'] . "</" . PROP_PARTNER . ">" . NEW_LINE;
			$res .= "\t</" . PROP_LIST . ">" . NEW_LINE;
		}
	}
	
	else if ($action == ACTION_TYPE_FIND) {
		$array_partner = get_random_user_without_partner($connection, $user_name);
		if ( $array_partner ) {
			$res .= "\t<" . PROP_PARTNER . ">" . NEW_LINE;
			$res .= "\t\t<" . PROP_USER . ">" . $array_partner['username'] . "</" . PROP_USER . ">" . NEW_LINE;
			$res .= "\t\t<" . PROP_ID . ">" . $array_partner['id'] . "</" . PROP_ID . ">" . NEW_LINE;
			$res .= "\t\t<" . PROP_STATUS . ">" . $array_partner['status'] . "</" . PROP_STATUS . ">" . NEW_LINE;
			$res .= "\t\t<" . PROP_DISABLED . ">" . $array_partner['disabled'] . "</" . PROP_DISABLED . ">" . NEW_LINE;
			$res .= "\t\t<" . PROP_REPORTER_DISABLED . ">" . $array_partner['reporterdisabled'] . "</" . PROP_REPORTER_DISABLED . ">" . NEW_LINE;
			$res .= "\t</" . PROP_PARTNER . ">" . NEW_LINE;
		}
	}
	else if ($action == ACTION_TYPE_REPORT) {
		report($connection, $partner, $user_name);
	}
	else {
		$res .= "\t<" . PROP_ERROR . ">Unhandled action type [" . $action . "]</" . PROP_ERROR . ">" . NEW_LINE;
		throw new Exception("Unhandled action type: " . $action);
	}

	$res .= "\t<" . PROP_SUCCESS . ">true</" . PROP_SUCCESS . ">" . NEW_LINE;
} catch (Exception $ex) {
	$res .= "\t<" . PROP_SUCCESS . ">false</" . PROP_SUCCESS . ">" . NEW_LINE;
}

$res .= "</" . PROP_RESULT . ">" . NEW_LINE;

// $username_array = xmlstr_to_array("<xml><boddy>vincent</boddy><p2> zhu</p2></xml>");
// 
// $username_part = generate_xml_from_array($username_array);
// echo $username_part;
echo $res;
// echo $code ;
//  echo $action; 
//  echo $user_name ;
//  echo $_GET[GET_ID];
//  echo $partner;
//  echo $status ;
?>
