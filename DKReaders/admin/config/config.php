<?
session_start();

	
	if(isset($_COOKIE['login_username'])){
		$_SESSION['login_username'] = $_COOKIE['login_username'];
		$_SESSION['login_region'] = $_COOKIE['login_region'];
		// ### save login session to be the remebered cookie value
	} else {
	
		if(($_SESSION['login_username'] == '' || isset($_SESSION['login_username']) === false) && (basename($_SERVER['PHP_SELF']) != 'login.php' && basename($_SERVER['PHP_SELF']) != 'data.php' && basename($_SERVER['PHP_SELF']) != 'book.php' && basename($_SERVER['PHP_SELF']) != 'book2.php') ){

			// ### user not logged in bounce to login screen but dosnt apply to theses pages (login.php / data.php / book.php)
			header('location:login.php');	
		}
	}


if($_REQUEST['logout']){
	// ### log user out
	$_SESSION['login_username'] = '';
	unset($_SESSION['login_username']);
	header('location:login.php');	
}


function connectMySqli(){
	// ### database connection check login session here and logout code
	return new mysqli('213.171.200.50','kokoSQL', 'k0k0786SQL','ReaderDB');
}

if($_REQUEST['error']=='1'){
// pass error=1 one will output errors
	ini_set('display_errors', 1);
	ini_set('log_errors', 1);
	ini_set('error_log', dirname(__FILE__) . '/error_log.txt');
	error_reporting(E_ALL);
}


?>