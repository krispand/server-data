<?
function checkSession($error=''){
	// check guid from header
	$tokensercurity = true; //.flag to globally turn token sercurity on and off for testing
	$headers = apache_request_headers();



	if($_REQUEST['t']=='607954b7836ee908b463bc61b23d5e14'|| $tokensercurity== false){ // turn token sercurity off when passing md5(tokenoff) used when admin previewing epubs
	
	} else{

		if($_SESSION['token'] != $headers['token'] || strlen($headers['token'])==0 || isset($headers['token']) ===false){

			if($error == '404'){
				header('HTTP/1.0 404 Not Found');
				die();
				// return 404 error
			} else{
				   $messagearray = array();
				   $messagearray['message'] = 'invalid session';
				   //$messagearray['TOKEN_EXPECTED'] = $_SESSION['token'];
				  // $messagearray['TOKEN_GOT'] = $headers['token'];
				   $wrapper = array();
				   $wrapper['error'][] = $messagearray;
				   header('Content-type: application/json');
				   die(json_encode($wrapper));
				//return error object
			}
		}
	}
}

function strToDBDate($value){
	$value = explode("/", $value);
	$newformat = $value[2].'-'.$value[1].'-'.$value[0];
	return $newformat;
}

function intNull($value,$default){
	if(isset($value) && strlen($value) > 0 && is_numeric($value)){
			return $value;
		}else{
			return $default;
	}
}

function GetCleanFileName($theValue){
	$normalizeChars = array(
    'Š'=>'S', 'š'=>'s', 'Ð'=>'Dj','Ž'=>'Z', 'ž'=>'z', 'À'=>'A', 'Á'=>'A', 'Â'=>'A', 'Ã'=>'A', 'Ä'=>'A', 
    'Å'=>'A', 'Æ'=>'A', 'Ç'=>'C', 'È'=>'E', 'É'=>'E', 'Ê'=>'E', 'Ë'=>'E', 'Ì'=>'I', 'Í'=>'I', 'Î'=>'I', 
    'Ï'=>'I', 'Ñ'=>'N', 'Ò'=>'O', 'Ó'=>'O', 'Ô'=>'O', 'Õ'=>'O', 'Ö'=>'O', 'Ø'=>'O', 'Ù'=>'U', 'Ú'=>'U', 
    'Û'=>'U', 'Ü'=>'U', 'Ý'=>'Y', 'Þ'=>'B', 'ß'=>'Ss','à'=>'a', 'á'=>'a', 'â'=>'a', 'ã'=>'a', 'ä'=>'a', 
    'å'=>'a', 'æ'=>'a', 'ç'=>'c', 'è'=>'e', 'é'=>'e', 'ê'=>'e', 'ë'=>'e', 'ì'=>'i', 'í'=>'i', 'î'=>'i', 
    'ï'=>'i', 'ð'=>'o', 'ñ'=>'n', 'ò'=>'o', 'ó'=>'o', 'ô'=>'o', 'õ'=>'o', 'ö'=>'o', 'ø'=>'o', 'ù'=>'u', 
    'ú'=>'u', 'û'=>'u', 'ý'=>'y', 'ý'=>'y', 'þ'=>'b', 'ÿ'=>'y', 'ƒ'=>'f'
	);
	$strIllegalChars = "\/$'.,;£:@^#~]}{[=+*^%!`¬|><?";
		for($i=0; $i<strlen($strIllegalChars);) {
			// loop illegal characters and remove them
				$theValue = str_replace($strIllegalChars[$i],'',$theValue);
				$theValue = str_replace('"','',$theValue);
				$theValue = str_replace(' ','_',$theValue);
				$i++;
			}
return strtolower(strtr($theValue,$normalizeChars));

}
function GetFileUnique($thePath, $theFile, $ext){
		$i = 0; 
		do{$i++;} while (file_exists($thePath.$theFile."_".$i.$ext));
		return $theFile.'_'.$i;
}
function guid(){
    if (function_exists('com_create_guid')){
        return str_replace('}','',str_replace('{','',str_replace('-','',com_create_guid())));
    }else{
        mt_srand((double)microtime()*10000);//optional for php 4.2.0 and up.
        $charid = strtoupper(md5(uniqid(rand(), true)));
        $uuid = substr($charid, 0, 8).substr($charid, 8, 4).substr($charid,12, 4).substr($charid,16, 4).substr($charid,20,12);
        return $uuid;
    }
}
?>