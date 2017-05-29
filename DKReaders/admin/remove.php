<?
 require('config/config.php'); 
 
 if($_REQUEST['type']){
	 $sqltable = '';
	 $orderfield = '';
	 $idfield = '';
	 
	 if($_REQUEST['type'] =='promo'){
		$sqltable = 'promotions';
	 	$orderfield = 'promo_order';
	 	$idfield = 'promo_auto_id';
	 }
	 
	 if($_REQUEST['type'] =='funfact'){
		$sqltable = 'funfacts';
	 	$orderfield = 'funfact_order';
	 	$idfield = 'funfact_auto_id';
	 }
	 
	 if($_REQUEST['type'] =='helpmain'){
		$sqltable = 'helppages';
	 	$orderfield = 'helppage_section_order';
	 	$idfield = 'helppage_section_guid';
	}
	
	if($_REQUEST['type'] =='helpsub'){
		$sqltable = 'helppages';
	 	$orderfield = 'helppage_order';
	 	$idfield = 'helppage_auto_id';
	}
	 
	 
	$sql = '';
	$id = $_REQUEST['id'];
	
	$mysqli = connectMySqli();
	$sql = 'DELETE FROM '.$sqltable.' WHERE '.$idfield.' = ?';

    $stmt = $mysqli->prepare($sql);
    // "s" means the database expects a string
    $stmt->bind_param('s', $id);
    $stmt->execute();
    $stmt->close();
    $mysqli->close();
	 
	
 }
 ?>