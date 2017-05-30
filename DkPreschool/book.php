<?
require('admin/config/config.php'); 
require('admin/config/misc.php'); 
//$serverName = "C:\xampp\htdocs\preschoolcms/";
$serverName = "";
//### load epub via php page to hide its orgin on the server using .htaccess file to deliver the correct book variables

checkSession('404'); //### check users session via header and bounce to 404 if incorrect or expired
set_time_limit(0); 

if($_REQUEST['id']){
	
		$sql = 'CALL funcGetEPUB('.$_REQUEST['id'].')';
		$mysqli = connectMySqli();
		$result = $mysqli->query($sql);
		$row = $result->fetch_object();
	
		
	if($row){
		
		$bookfilename = $row->book_epub;
		$booksamplefilename = $row->book_sample_epub;
		$bookpath =$serverName.'assets/books/epubs/';
		$booksamplepath = $serverName.'assets/books/epubsamples/';
		$returnedname = 'book-'.$row->book_auto_id.'.epub';
		$filepath = $bookpath.$bookfilename;
		//echo "File Name is ".$filepath;
		//echo "file Returned Path ".$returnedname;
		//die();
		if($_REQUEST['sample']=='1'){
			$filepath = $booksamplepath.$booksamplefilename;
			$returnedname = 'book-sample-'.$row->book_auto_id.'.epub';
		}

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
		
	} else{
	//### send 404 response 
	header('HTTP/1.0 404 Not Found');
	die();
	}
	
}
?>
