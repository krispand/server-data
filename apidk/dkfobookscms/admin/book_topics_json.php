<?
 require('config/config.php'); 

 if($_REQUEST['term']){
	$searchStr = $_REQUEST['term'];
	$colsArray = array('topic_name');
 	// ### get records for page
 	$sql = 'CALL funcGetRecords(\'topics\',\''.implode(',',$colsArray).'\',\''.$searchStr.'\',\'0\','.$_SESSION['login_region'].')';
	$mysqli = connectMySqli();
	$result = $mysqli->query($sql);
	$recordcount = 0;
	$dcArray = array();
	if($result){
	 while ($row = $result->fetch_object()) {
        $dcArray[$recordcount] = array();
		foreach ($colsArray as $cols) {
			// ### get col name save data to array
			$dcArray[$recordcount]['label'] = str_replace('|','',$row->$cols);
		}
		$recordcount++;
	 }
	}
 }

    header('Content-type: application/json');
    die(json_encode($dcArray));
 ?>
 
 