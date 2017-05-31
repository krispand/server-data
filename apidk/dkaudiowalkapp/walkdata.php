<?php
if($_REQUEST['id'])
{	
		$pkg = $_REQUEST['id'];
 		$barcode=$_REQUEST['barcode'];		
 		$bookpath = 'walkdata/'.$barcode.'/';	
		$bookfilename = $pkg .'.zip';
		$filepath = $bookpath.$bookfilename;
		if (file_exists($filepath)){
			//### if file exists then serve it
  	        header("X-Sendfile:$filepath");
			header("Content-Type: application/octet-stream");
			header("Content-Disposition: attachment; filename=\"$bookfilename\"");
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
