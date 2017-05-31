<?php
if($_REQUEST['id']){
	
		$lang = $_REQUEST['id'];
		$bookpath = 'soundfiles/';
		$returnedname = $lang.'.zip';
		$filepath = $bookpath.$returnedname;
		if (file_exists($filepath)){
			//### if file exists then serve it
  	        header("X-Sendfile: $filepath");
			header("Content-Type: application/octet-stream");
			header("Content-Disposition: attachment; filename=\"$returnedname\"");
		
			exit;
		} else {
			//### send 404 response 
			header('HTTP/1.0 404 Not Found');
			die();
		}
		
	}
 else{
	//### send 404 response 
	header('HTTP/1.0 404 Not Found');
	die();
	}
?>
