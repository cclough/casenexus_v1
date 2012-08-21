<?php

include "../config/config.php";


function getIP() {
	$ip = "UNKNOWN";
	if ( getenv("HTTP_CLIENT_IP") ) $ip = getenv("HTTP_CLIENT_IP");
	else if( getenv("HTTP_X_FORWARDED_FOR") ) $ip = getenv("HTTP_X_FORWARDED_FOR");
	else if( getenv("REMOTE_ADDR") ) $ip = getenv("REMOTE_ADDR");
	return $ip;
}

function startsWith($haystack, $needle) {
	$length = strlen($needle);
	return (substr($haystack, 0, $length) === $needle);
}
function endsWith($haystack, $needle) {
	$length = strlen($needle);
	$start  = $length * -1; //negative
	return (substr($haystack, $start) === $needle);
}

/**
 * convert xml string to php array - useful to get a serializable value
 *
 * @param string $xmlstr
 * @return array
 * @author Adrien aka Gaarf
 */
function xmlstr_to_array($xmlstr) {
	$doc = new DOMDocument();
	$doc->loadXML($xmlstr);
	return domnode_to_array($doc->documentElement);
}
function domnode_to_array($node) {
	$output = array();
	switch ( $node->nodeType ) {
		case XML_CDATA_SECTION_NODE:
		case XML_TEXT_NODE:
			$output = trim($node->textContent);
			break;
		case XML_ELEMENT_NODE:
			for ( $i = 0, $m = $node->childNodes->length; $i < $m; $i++ ) {
				$child = $node->childNodes->item($i);
				$v = domnode_to_array($child);
				if ( isset($child->tagName) ) {
					$t = $child->tagName;
					if ( !isset($output[$t]) ) {
						$output[$t] = array();
					}
					$output[$t][] = $v;
				} elseif ( $v ) {
					$output = (string) $v;
				}
			}
			if ( is_array($output) ) {
				if ( $node->attributes->length ) {
					$a = array();
					foreach ( $node->attributes as $attrName => $attrNode ) {
						$a[$attrName] = (string) $attrNode->value;
					}
					$output['@attributes'] = $a;
			}
			foreach ( $output as $t => $v ) {
				if ( is_array($v) && count($v) == 1 && $t != '@attributes' ) {
					$output[$t] = $v[0];
				}
			}
		}
		break;
	}
	return $output;
}

function generate_xml_from_array($array, $node_name = "nr_") {
	$xml = "";
	if ( is_array($array) || is_object($array) ) {
		foreach ( $array as $key => $value ) {
			if ( is_numeric($key) ) {
				$key = $node_name;
			}
			$xml .= "<" . $key . ">" . generate_xml_from_array($value, $node_name) . "</" . $key . ">";
		}
	} else {
		$xml = htmlspecialchars($array, ENT_QUOTES);
	}
	return $xml;
}

?>
