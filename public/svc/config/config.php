<?php
/**
 * Configuration file for SVC-SR 0.6+
 * Help: http://www.videosoftware.pro/forum/THREAD-Installing-and-configuring-SVC-SR-video-chat
 */

/* database configuration */
$MYSQL_DB_HOST = "localhost";                 // database host
$MYSQL_DB_PORT = "3306";                      // database port (optional)
$MYSQL_DB_USER = "root";          // database username
$MYSQL_DB_PASS = "zhu1230";              // database password
$MYSQL_DB_NAME = "videochat";          // database name

$VALID_INTERVAL = 15;                         // sec.

/* connection settings */
$PING_INTERVAL = 5 * 1000;                    // sec. - ping server for updates every N seconds
$REQUEST_CONFIG_INTERVAL = 60 * 60000;        // min. - reload configuration file after N minutes
$INVITATION_SENT_TIMEOUT = 3 * 1000;          // sec. - timeout to wait for a serponse (available/busy) from a pinged partner; starts after ping was sent
$FIND_NEXT_BUTTON_ACTIVATION_TIMEOUT = 5;     // sec. - timeout (countdown) before NEXT button is activated; starts after successful connection
$FIND_NEXT_ACTIVATION_TIMEOUT = 2 * 1000;     // sec. - idle (available) timeout before SVC starts to look for a new partner; starts after NEXT is pressed
$VALIDATION_CODE = "136699";

/* system settings */
$HIDE_AGE_FEMALE = true;                      // hide age if user is female (true/false) 
$HIDE_AGE_MALE = false;                       // hide age if user is male (true/false)
$FILTER_DENSITY = 15;                         // number between 0-255 (the bigger will be more blurred)

$REPORTS_MAX_ALLOWED_PER_DAY = 5;             // after this number all the rest connection video display will be blured for today
$REPORTS_ABUSE_DETECTION_STRATEGY = "IP";     // possible values: IP, USER. Determines the used strategy when detecting user abuse if the reported number is higher than $REPORTS_MAX_ALLOWED_PER_DAY

// Please edit /config/config.xml to set service and config URLs and locale

?>