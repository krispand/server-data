<?php
require('admin/config/config.php'); 
require('admin/config/misc.php'); 
$action = $_REQUEST['action'];
$CR = chr(13);
$guid = guid();
$url = 'http://'.$_SERVER['HTTP_HOST'].str_replace('/data.php','',$_SERVER['SCRIPT_NAME']).'/';
$appVersionNo = '1.0'; //### change this when new app realease on app store
$checkAppVersionBool = false; //### fail safe to turn off app version check
$iTunesLink = 'itms://itunes.com/app/id720199396'; //### itunes link to app on apples website
$googleplaylink = ''; //### google app store link to the app

switch ($action) {
	
	 case 'storeconfig':
		// ### get last book modified by region code
		
		$regionCode = $_REQUEST['region'];	
		$sql = 'CALL funcGetModDate(\''.$regionCode.'\')';
		$mysqli = connectMySqli();
		$result = $mysqli->query($sql);
		$row = $result->fetch_object();
		
		$modDate = date('Y-m-d H:i:s'); //$row->book_datemodified;
		$_SESSION['token'] = md5(substr($modDate,0,10).$guid.substr($modDate,-10));
		$array = array();
		$array['token'] = $guid;
		$array['mod_date'] = $modDate;
		$array['app_version'] = $appVersionNo;
		$array['app_version_check'] = $checkAppVersionBool;
		$array['ituneslink'] = $iTunesLink;
		$array['googleplaylink'] = $googleplaylink;
        	$wrapper = array();
       		$wrapper['storeconfig'] = $array;

		header('Content-type: application/json');
		die(json_encode($wrapper));  
		
	 break;
	 
	 case 'storeget':
	 	// ### get book store json object
		
		checkSession();//### check users session via header and send error object if incorrect or expired
		
		$status = '';
		if($_REQUEST['d']=='1'){
			$status = 'DRAFT';
		}
		
		$regionCode = $_REQUEST['region'];	
		$sql = 'CALL funcGetStore(\''.$regionCode.'\',\''.$status.'\')';
		$mysqli = connectMySqli();
		$result = $mysqli->query($sql);
		
		$mainarray = array();
		
		 while ($row = $result->fetch_object()) {
                  $book = array();
		  $topics = array();

		if(is_numeric(strpos($row->book_topics,','))===true) {
			$topics = explode(',',str_replace('|','',$row->book_topics));
			} else {
			$topics[0] = str_replace('|','',$row->book_topics);
			
		}


				  $book['bookUID'] = intval($row->book_auto_id);
				  $book['bookTitleString'] = $row->book_title;
				  $book['readerLevelInt'] = intval($row->readerlevel_level);
				  $book['bookShortDescriptionString'] = $row->book_short_desc;
				  $book['bookLongDescriptionString'] = $row->book_long_desc;
				  $book['authorString'] = $row->book_author_name;
				  $book['bookImageURL'] = $url.'assets/books/images/'.$row->book_image;
				  $book['isNewBookBool'] = intval($row->book_new);
				  $book['topicList'] = $topics; //array
				  $book['bookIAPStringIOS'] = $row->book_apple_purchase_id;
				  $book['bookIAPStringGoogle'] = $row->book_android_purchase_id;
				  $book['epubDownloadURL'] = (strlen($row->book_epub)>4) ? $url.'book.php?id='.$row->book_auto_id.'' : '';
				  $book['epubSampleDownloadURL'] = (strlen($row->book_sample_epub)>4) ? $url.'book.php?id='.$row->book_auto_id.'&sample=1' : '';
				  $book['isFeaturedBool'] = intval($row->book_feature);
				  $book['isFreeBool'] = intval($row->book_free);
				  $book['isOnOfferBool'] = intval($row->book_onoffer);
				  $book['isAudioEnabled'] = intval($row->book_readaloud);
				  $book['publicationDateString'] = $row->book_publication_date;
				  
				  $mainarray['modifiedDate'] = $row->lastmoddate;
				  $mainarray['bookStoreData'][] = $book;
		 }
		
		$wrapper = array();
 		$wrapper['bookResult'] = $mainarray;

		header('Content-type: application/json');
		die(json_encode($wrapper));  

	 break;
	 
	 case 'promosget':
	 	 // ### get promotions json object
		checkSession();//### check users session via header and send error object if incorrect or expired
		
		
		$status = '';
		if($_REQUEST['d']=='1'){
			$status = 'DRAFT';
		}
		
		$regionCode = $_REQUEST['region'];	
		$sql = 'CALL funcGetPromos(\''.$regionCode.'\',\''.$status.'\')';
		$mysqli = connectMySqli();
		$result = $mysqli->query($sql);
		
		$mainarray = array();
		
		 while ($row = $result->fetch_object()) {
			 $promo = array();
			 $promo['promoUID'] = intval($row->promo_auto_id);
			 $promo['promoTitleString'] = $row->promo_title;
			 $promo['promoImageURL'] = (strlen($row->promo_image) > 4) ? $url.'assets/promos/'.$row->promo_image : '';
			 $promo['promoImageLrgURL'] = (strlen($row->promo_image_lrg) > 4) ? $url.'assets/promos/'.$row->promo_image_lrg : '';
			 $promo['isCollectionBool'] = intval($row->promo_type);
 			 $promo['collectionBookIDs'] = (is_numeric(strpos($row->promo_book_ids,','))===true) ? array_map('intval', explode(',',$row->promo_book_ids))  : NULL; 
			 $promo['singleBookID'] = (is_numeric(strpos($row->promo_book_ids,','))===true) ? NULL : intval($row->promo_book_ids);
			 
			 $mainarray['modifiedDate'] = $row->lastmoddate;
			 $mainarray['promoData'][]= $promo;
		 }
		 
		$wrapper = array();
 		$wrapper['promoResults'] = $mainarray;
	
		header('Content-type: application/json');
		die(json_encode($wrapper));  
	 break;
	
	  case 'funfactsget':
	 	 // ### get promotions json object
		checkSession();//### check users session via header and send error object if incorrect or expired
		$status = '';
		if($_REQUEST['d']=='1'){
			$status = 'DRAFT';
		}
		$regionCode = $_REQUEST['region'];	
		$sql = 'CALL funcGetFunfacts(\''.$regionCode.'\',\''.$status.'\')';
		$mysqli = connectMySqli();
		$result = $mysqli->query($sql);
		
		$mainarray = array();
		
		 while ($row = $result->fetch_object()) {
			 $fun = array();
			 $fun['funfactUID'] = intval($row->funfact_auto_id);
			 $fun['funfactTitleString'] = $row->funfact_title;
			 $fun['funfactImageURL'] = (strlen($row->funfact_image) > 4) ? $url.'assets/funfacts/'.$row->funfact_image : '';
			 
			 $mainarray['modifiedDate'] = $row->lastmoddate;
			 $mainarray['funfactData'][] = $fun;
		 }
		 
		$wrapper = array();
 		$wrapper['funfactResults'] = $mainarray;


		header('Content-type: application/json');
		die(json_encode($wrapper));  
	 break;
	 
	 case 'helppagesget':
	 	 	// ### get helppages json object
		
		checkSession();//### check users session via header and send error object if incorrect or expired
		$status = '';
		if($_REQUEST['d']=='1'){
			$status = 'DRAFT';
		}
		$regionCode = $_REQUEST['region'];	
		$sql = 'CALL funcGetHelppages(\''.$regionCode.'\',\''.$status.'\')';
		$mysqli = connectMySqli();
		$result = $mysqli->query($sql);
		
		$mainarray = array();
		$categoryarray = array();
		$i = 0;
		$strCategoryTitle= '';
		
		 while ($row = $result->fetch_object()) {
			
			 
			 $page = array();
			 $page['pageID'] = intval($row->helppage_auto_id);
			 $page['pageTitleString'] = $row->helppage_title;
			 $page['pageTemplateID'] = intval($row->helppage_template_id);
			 $page['pageTemplateImageURL'] = (strlen($row->helppage_image) > 4) ? $url.'assets/helppages/'.$row->helppage_image : '';
			 $page['pageCopyString'] = $row->helppage_content;
			
				if($strCategoryTitle!= $row->helppage_section){
						// ### add category details 
					 if(strlen($strCategoryTitle)>1){
						$i++;
					 }
					 $strCategoryTitle = $row->helppage_section;
					 $mainarray['modifiedDate'] = $row->lastmoddate;
					 $mainarray['helpData'][]['categoryTitleString'] = $strCategoryTitle;	 
				}
			
			 
			 $mainarray['helpData'][$i]['categoryPages'][] = $page;
		 }
		 
		$wrapper = array();
 		$wrapper['helpSection'] = $mainarray;


		header('Content-type: application/json');
		die(json_encode($wrapper));  
	 break;
	 
	
	 case 'forget':
	  //### send forgotten user info via email


		require('admin/config/class.phpmailer.php'); // EMAIL FUNCTIONS
		
		$regionCode = $_REQUEST['region'];	
		$sql = 'CALL funcGetEmail(\''.$regionCode.'\',1)';
		$mysqli = connectMySqli();
		$result = $mysqli->query($sql);
		$row = $result->fetch_object();

		$strSubject  = $row->email_subject;
		$strBody= $row->email_body;
		$email_address = $_REQUEST['email'];
		$pinnumber = $_REQUEST['pin'];
		
		$strBody = str_replace('[#PIN#]',$pinnumber,$strBody);
  
		$mail = new PHPMailer();
		$mail->IsHTML(false); 
		$mail->From = 'no-reply@dkreaderapp.com';
		$mail->FromName = 'DK Reader App';
		$mail->AddAddress($email_address,$email_address);
		$mail->Subject = $strSubject;
		$mail->Body = $strBody;
		$array = array();
		
		if(!$mail->Send()){
			
		   $messagearray = array();
		   $messagearray['message'] = 'error send mail';
		   $messagearray['detail'] = $mail->ErrorInfo;
		   $wrapper = array();
		   $wrapper['error'][] = $messagearray;
		   header('Content-type: application/json');
		   die(json_encode($wrapper));
			
		} else {
		   $array['message'] = 'message sent';
		}
		
		$wrapper = array();
		$wrapper['response'] = $array;

		header('Content-type: application/json');
		die(json_encode($wrapper));

	  
	 break;
	 
	 
	 
}

?>