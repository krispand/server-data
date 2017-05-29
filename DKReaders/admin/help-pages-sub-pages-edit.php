<?
 require('config/config.php');
 require('config/misc.php'); 
 require('config/upload.php');
 

 $promoCols = array('helppage_title','helppage_image','helppage_template_id','book_region_id','helppage_section_guid','helppage_section','helppage_section_status','helppage_status','helppage_content');

  // ### set default data filter criteria here
	$searchStr = '';
	$colsArray = array('helppage_title','helppage_image','helppage_auto_id','helppage_section_guid','region_code','helppage_section','helppage_section_status','helppage_region_id','helppage_order','helppage_content','helppage_template_id','helppage_status');
 	// ### get records for page
 	$sql = 'CALL funcGetRecords(\'helpsubed\',\''.implode(',',$colsArray).'\',\''.addslashes($searchStr).'\',\''.$_REQUEST['sid'].'\','.$_REQUEST['rid'].')';
	$mysqli = connectMySqli();
	$result = $mysqli->query($sql);
	$helpArray = array();
	
	if($result){
	 while ($row = $result->fetch_object()) {
		foreach ($colsArray as $cols) {
			// ### get col name save data to array
			$helpArray[$cols] = $row->$cols;
		}
		$recordcount++;
	 }
	}


 
 if($_POST['helppage_title']){
 // ### Start insert of record


 	if ($_FILES['helppage_image']['tmp_name']!=''){
			// ### upload image
			$width = 414;
			$height = 715;
			
			if($_POST['helppage_template_id']=='3'){
				$width = 1024;
				$height = 298;
			}
			
			
			$imagePath = '../assets/helppages/';
			$imagename = GetCleanFileName(preg_replace("/[^A-Za-z0-9 ]/", '',$_POST['helppage_title']));
			$imagename = GetFileUnique($imagePath,$imagename,substr(strrchr($_FILES['helppage_image']['name'],'.'),0));
			uploadfile('image','helppage_image',$imagename,$imagePath,$width,$height);
			$imagename = $imagename.substr(strrchr($_FILES['helppage_image']['name'],'.'),0);
		} else {
			$imagename = $helpArray['helppage_image'];
	}
	
	
	if(is_numeric(strpos($_POST['helppage_section'],'||'))===true){
		$array = explode('||',$_POST['helppage_section']);
		$strSGUID = $array[0];
		$strSTitle = $array[1];
		$strSStatus = $array[2];
		$intSOrder =  $array[3];
	} else {
		$strSGUID = guid();
		$intSOrder = 0;
		$strSTitle = $_POST['helppage_section'];
		$strSStatus = $_POST['helppage_section_status'];
	}



		 $sql ='CALL funcSaveHelp(\'save\',\''.addslashes($_POST['helppage_title']).'\',\''.$imagename.'\','.intNull($_POST['book_region_id'],1).',\''.$_POST['helppage_status'].'\','.$_POST['helppage_template_id'].',\''.addslashes($_POST['helppage_content']).'\','.$_REQUEST['sid'].',\''.$strSGUID.'\','.$intSOrder.',\''.addslashes($strSTitle).'\',\''.$strSStatus.'\')';
	 
		$mysqli = connectMySqli();
		$result = $mysqli->query($sql);
		
		header('location:help-pages-edit.php?sid='.$_REQUEST['sid'].'&sect='.$strSTitle.'&id='.$strSGUID.'&rid='.$_REQUEST['rid']);
	
 }

 ?>
<!DOCTYPE html>
<!--[if IE 8]> <html lang="en" class="ie8"> <![endif]-->
<!--[if IE 9]> <html lang="en" class="ie9"> <![endif]-->
<!--[if !IE]><!--> <html lang="en"> <!--<![endif]-->
<!-- BEGIN HEAD -->
<head>
    <meta charset="utf-8" />
   <title><?=ucwords(strtolower(str_replace('.php','',str_replace('-',' ',basename($_SERVER['PHP_SELF'])))));?></title>
    <meta content="width=device-width, initial-scale=1.0" name="viewport" />
    <meta content="" name="description" />
    <meta content="" name="author" />
    <link href="assets/bootstrap/css/bootstrap.min.css" rel="stylesheet" />
    <link href="assets/bootstrap/css/bootstrap-responsive.min.css" rel="stylesheet" />
    <link href="assets/bootstrap/css/bootstrap-fileupload.css" rel="stylesheet" />
    <link href="assets/font-awesome/css/font-awesome.css" rel="stylesheet" />
    <link href="css/style.css" rel="stylesheet" />
    <link href="css/style-responsive.css" rel="stylesheet" />
    <link href="css/style-default.css" rel="stylesheet" id="style_color" />

    <link href="assets/fancybox/source/jquery.fancybox.css" rel="stylesheet" />
    <link rel="stylesheet" type="text/css" href="assets/uniform/css/uniform.default.css" />

    <link rel="stylesheet" type="text/css" href="assets/chosen-bootstrap/chosen/chosen.css" />
    <link rel="stylesheet" type="text/css" href="assets/jquery-tags-input/jquery.tagsinput.css" />
    <link rel="stylesheet" type="text/css" href="assets/clockface/css/clockface.css" />
    <link rel="stylesheet" type="text/css" href="assets/bootstrap-wysihtml5/bootstrap-wysihtml5.css" />
    <link rel="stylesheet" type="text/css" href="assets/bootstrap-datepicker/css/datepicker.css" />
    <link rel="stylesheet" type="text/css" href="assets/bootstrap-timepicker/compiled/timepicker.css" />
    <link rel="stylesheet" type="text/css" href="assets/bootstrap-colorpicker/css/colorpicker.css" />
    <link rel="stylesheet" href="assets/bootstrap-toggle-buttons/static/stylesheets/bootstrap-toggle-buttons.css" />
    <link rel="stylesheet" type="text/css" href="assets/bootstrap-daterangepicker/daterangepicker.css" />

    <link rel="stylesheet" href="http://code.jquery.com/ui/1.10.3/themes/smoothness/jquery-ui.css" />



</head>
<!-- END HEAD -->
<!-- BEGIN BODY -->

<body class="fixed-top">
<!-- BEGIN HEADER -->
<? require('includes/header.php'); ?>
<!-- END HEADER -->
 
  <!-- BEGIN CONTAINER -->
   <div id="container" class="row-fluid">
      <!-- BEGIN SIDEBAR -->
      <div class="sidebar-scroll">
          <div id="sidebar" class="nav-collapse collapse">

              <!-- BEGIN RESPONSIVE QUICK SEARCH FORM -->
              <div class="navbar-inverse">
                  <form class="navbar-search visible-phone">
                      <input type="text" class="search-query" placeholder="Search" />
                  </form>
              </div>
              <!-- END RESPONSIVE QUICK SEARCH FORM -->

<!-- BEGIN SIDEBAR MENU -->
<? require('includes/mainnav.php'); ?>
<!-- END SIDEBAR MENU -->

</div> </div>
<!-- END SIDEBAR -->

<!-- BEGIN PAGE -->
      <div id="main-content">
         <!-- BEGIN PAGE CONTAINER-->
         <div class="container-fluid">
            <!-- BEGIN PAGE HEADER-->
            <div class="row-fluid">
               <div class="span12">
           		<!-- BEGIN PAGE TITLE & BREADCRUMB-->
                    <? require('includes/breadcrumb.php'); ?>
                 <!-- END PAGE TITLE & BREADCRUMB-->
               </div>
            </div>
<!-- END PAGE HEADER-->


<!-- BEGIN PAGE CONTENT-->


<!--BEGIN METRO STATES-->
<form action="" method="post" id="helppageForm" enctype="multipart/form-data" class="cmxform form-horizontal" >

<div class="row-fluid">
<div class="span12">

<!-- BEGIN widget-->
<div class="widget black">
      <div class="widget-title"><h4><i class="icon-reorder"></i> Edit Help Sub Page</h4>
      <span class="tools">
      <a href="javascript:;" class="icon-chevron-down"></a>

      </span>
      </div>


<div class="widget-body">
<!-- BEGIN FORM-->


<div class="control-group">
<label for="helppage_title" class="control-label">Help Page Title</label>
<div class="controls">
	<div id="helppage_title-e" class="span4"><div class="icon-exclamation-sign"></div>
	<input id="helppage_title" name="helppage_title" type="text"  style="width:95%" maxlength="220" value="<?=$helpArray['helppage_title']?>"/>
   
    </div>
</div></div>

<div class="control-group">
<label class="control-label">Help Page Template</label>
<div class="controls">
<div class="span4" id="helppage_template_id-e"><div class="icon-exclamation-sign"></div>
<select id="helppage_template_id" name="helppage_template_id" class="chzn-select" tabindex="1">
<option value="">Select...</option>
<option value="1" <?=($helpArray['helppage_template_id']=='1') ? 'selected': ''?>>Left Aligned Content</option>
<option value="2" <?=($helpArray['helppage_template_id']=='2') ? 'selected': ''?>>Right Aligned Content</option>
<option value="3" <?=($helpArray['helppage_template_id']=='3') ? 'selected': ''?>>Bottom Aligned Content</option>
</select>
</div><div id="templateIcon" style="width:50px;height:50px;float:left;margin-left:10px"><img style="display:none" src="img/top-image.png"/></div></div>
</div>



<div class="control-group">
<?
$width = 414;
$height = 715;

if($helpArray['helppage_template_id']=='3'){
	$width = 1024;
	$height = 298;
}

?>


<label for="helppage_image" class="control-label" id="imagesizes">Image Upload<br>
(w <?=$width?> x h <?=$height?>px)</label>
<div class="controls">
<div data-provides="fileupload" class="fileupload fileupload-exists" data-name="book-image" required>
<div style="width: 200px; height: 150px;" class="fileupload-new thumbnail"></div>
<div style="max-width: 200px; max-height: 150px; line-height: 20px;" class="fileupload-preview fileupload-exists thumbnail"><a href="<?= (strlen($helpArray['helppage_image'])>3)? '../assets/helppages/'.$helpArray['helppage_image'] : 'http://www.placehold.it/200x150/EFEFEF/AAAAAA&amp;text=no+image'?>"  target="_blank"><img alt="" src="<?= (strlen($helpArray['helppage_image'])>3)? '../assets/helppages/'.$helpArray['helppage_image'] : 'http://www.placehold.it/200x150/EFEFEF/AAAAAA&amp;text=no+image'?>"></a></div>
<div><span class="btn btn-file"><span class="fileupload-new">Select image</span><span class="fileupload-exists">Change</span>
<input type="file" id="helppage_image" name="helppage_image" class="default"></span>
</div>
</div></div></div>







<input id="book_region_id" name="book_region_id" type="hidden" value="<?=$_REQUEST['rid']?>" />


<div class="control-group">
<label for="helppage_content" class="control-label">Content</label>
<div class="controls">
<div id="helppage_content-e" class="span4"><div class="icon-exclamation-sign"></div>
<textarea id="helppage_content" name="helppage_content" style="width:95%" rows="6" maxlength="15000" ><?=$helpArray['helppage_content']?></textarea>
</div>
</div></div>
<div class="control-group">
<label class="control-label">Help Page Status</label>
<div class="controls">
<div class="span4">
<select name="helppage_status" class="chzn-select" tabindex="1">
<option value="DRAFT" <?=($helpArray['helppage_status']=='DRAFT') ? 'selected' : '' ?>>Draft</option>
<option value="LIVE"  <?=($helpArray['helppage_status']=='LIVE') ? 'selected' : '' ?>>Live</option>
</select>
</div></div>
</div>
                         

<!-- END FORM-->
</div>
</div>
<!-- END widget-->

</div>
</div>
<div class="row-fluid">

<div class="span12">
<!-- BEGIN widget-->
<div class="widget green"><div class="widget-title">
<h4><i class="icon-reorder"></i> Save Details</h4>
<span class="tools"><a href="javascript:;" class="icon-chevron-down"></a></span>
</div>

<div class="widget-body">

<!-- BEGIN FORM-->

<?
// ## if master show this option else use users loggedin region 
// get reigons from database
	$searchStr = "";
	$rid = $_SESSION['login_region'];
	
	
	$colsArray = array('helppage_section_guid','helppage_section','helppage_section_status','helppage_section_order','helppage_region_id');
 	$sql = 'CALL funcGetRecords(\'helpmain\',\''.implode(',',$colsArray).'\',\''.$searchStr.'\',\'0\','. $_SESSION['login_region'].')';
	$mysqli = connectMySqli();
	$result = $mysqli->query($sql);
	$recordcount = 0;
	$sectionArray = array();
	
	if($result){
	 while ($row = $result->fetch_object()) {
        $sectionArray[$recordcount] = array();
		foreach ($colsArray as $cols) {
			// ### get col name save data to array
			$sectionArray[$recordcount][$cols] = $row->$cols;
		}
		$recordcount++;
	 }
	}
?>
<? if ($recordcount > 0){?>
<div class="control-group">
<label for="helppage_section-sel" class="control-label">Help Page Section</label>
<div class="controls">
	<div class="span4" id="helppage_section-sel-e"><div class="icon-exclamation-sign"></div>
<select name="helppage_section-sel" id="helppage_section-sel" class="chzn-select" data-placeholder="Select Section" tabindex="1">
	<option value="">Select...</option>
    <option value="new">+ New Section</option>
    <? $preSelected = '';?>
	<? 	foreach  ($sectionArray as $record) { ?>
    <option value="<?=$record['helppage_section_guid'].'||'.$record['helppage_section'].'||'.$record['helppage_section_status'].'||'.$record['helppage_section_order']?>" <?=($_REQUEST['id']==$record['helppage_section_guid']) ? 'selected' : '' ?> class="reg-<?=$record['helppage_region_id']?>"><?=$record['helppage_section']?></option>
    
    <? 
	if($_REQUEST['id']==$record['helppage_section_guid']){
		$preSelected = $record['helppage_section_guid'].'||'.$record['helppage_section'].'||'.$record['helppage_section_status'].'||'.$record['helppage_section_order'];
	}
	
	?>
    
    <? }?>
</select>
	</div>
	</div>
</div>
<? } ?>

<div id="helppage_section_new" style="display:<?=($recordcount > 0)?'none' : 'block'?>">
    <div class="control-group">
    <label for="helppage_section" class="control-label">Section Title</label>
        <div class="controls">
            <div id="helppage_section-e" class="span4"><div class="icon-exclamation-sign"></div>
            <input id="helppage_section" name="helppage_section" type="text"  style="width:95%" maxlength="220" value="<?=$preSelected?>"/>
            </div>
        </div>
    </div>
</div>

<div id="helppage_section_status_new" style="display:<?=($recordcount > 0)?'none' : 'block'?>">
    <div class="control-group">
        <label class="control-label">Section Status</label>
            <div class="controls">
                <div class="span4">
                    <select id="helppage_section_status" name="helppage_section_status" class="chzn-select" tabindex="1">
                    <option value="DRAFT">Draft</option>
                    <option value="LIVE">Live</option>
                    </select>
                </div>
            </div>
    </div>
</div>

<button type="submit" id="submit" class="btn btn-success">Save</button>
<button type="button" class="btn" onclick="window.location='help-pages-edit.php?sid=<?=$_REQUEST['sid']?>&sect=<?=$_REQUEST['sect']?>&id=<?=$_REQUEST['id']?>&rid=<?=$_REQUEST['rid']?>'">Cancel</button>





<!-- END FORM-->

</div></div>

<!-- END widget-->
</div>
</div>
</form>

<!--END METRO STATES-->
<!-- END PAGE CONTENT-->

</div>
<!-- END PAGE CONTAINER-->
</div>
<!-- END PAGE -->
</div>
<!-- END CONTAINER -->

	 <!-- BEGIN FOOTER -->
 	<? require('includes/footer.php'); ?>
   <!-- END FOOTER -->

   <!-- BEGIN JAVASCRIPTS -->
   <!-- Load javascripts at bottom, this will reduce page load time -->

   <script src="js/jquery-1.8.2.min.js"></script>
   <script src="js/jquery.nicescroll.js" type="text/javascript"></script>
   <script type="text/javascript" src="assets/ckeditor/ckeditor.js"></script>
   <script src="assets/bootstrap/js/bootstrap.min.js"></script>
   <script type="text/javascript" src="assets/bootstrap/js/bootstrap-fileupload.js"></script>
   <script src="js/jquery.blockui.js"></script>

   <script src="http://code.jquery.com/ui/1.10.3/jquery-ui.js"></script>
   <script src="js/jQuery.dualListBox-1.3.js" language="javascript" type="text/javascript"></script>


   <!-- ie8 fixes -->
   <!--[if lt IE 9]>
   <script src="js/excanvas.js"></script>
   <script src="js/respond.js"></script>
   <![endif]-->
   <script type="text/javascript" src="assets/bootstrap-toggle-buttons/static/js/jquery.toggle.buttons.js"></script>
   <script type="text/javascript" src="assets/chosen-bootstrap/chosen/chosen.jquery.js"></script>
   <script type="text/javascript" src="assets/uniform/jquery.uniform.min.js"></script>
   <script type="text/javascript" src="assets/bootstrap-wysihtml5/wysihtml5-0.3.0.js"></script>
   <script type="text/javascript" src="assets/bootstrap-wysihtml5/bootstrap-wysihtml5.js"></script>
   <script type="text/javascript" src="assets/clockface/js/clockface.js"></script>
   <script type="text/javascript" src="assets/jquery-tags-input/jquery.tagsinput.min.js"></script>
   <script type="text/javascript" src="assets/bootstrap-datepicker/js/bootstrap-datepicker.js"></script>
   <script type="text/javascript" src="assets/bootstrap-daterangepicker/date.js"></script>
   <script type="text/javascript" src="assets/bootstrap-daterangepicker/daterangepicker.js"></script>
   <script type="text/javascript" src="assets/bootstrap-colorpicker/js/bootstrap-colorpicker.js"></script>
   <script type="text/javascript" src="assets/bootstrap-timepicker/js/bootstrap-timepicker.js"></script>
   <script type="text/javascript" src="assets/bootstrap-inputmask/bootstrap-inputmask.min.js"></script>
   <script src="assets/fancybox/source/jquery.fancybox.pack.js"></script>
   <script src="js/jquery.scrollTo.min.js"></script>
   <script src="assets/jquery-slimscroll/jquery.slimscroll.min.js"></script>
   <script type="text/javascript" src="js/jquery.validate.min.js"></script>



   <!--common script for all pages-->
   <script src="js/common-scripts.js"></script>

   <!--script for this page-->
   <script src="js/form-component.js"></script>
  <!-- END JAVASCRIPTS -->

   <script language="javascript" type="text/javascript">
	 
	 function funcpages(regionid,state){
	 		var region = 'reg-'+regionid;
			var count = $('#helppage_section_sel_chzn li').length;
					console.log(count);
				$('#helppage_section_sel_chzn li').each(function(){
					
					if($(this).attr('class').indexOf('reg-')>-1){;
						if(region == 'reg-'){
							$(this).css('display','none');
							$(this).removeClass('result-selected');
							 count = 2;
						} else{
							if($(this).attr('class').indexOf(region)>-1){
								$(this).css('display','block');
							} else {
								$(this).css('display','none');
								count--;
							}
						}
						
					}
				});
				
				
				if((region == 'reg-' || count ==2 || state ==1) && $('#helppage_section_sel_chzn .chzn-single span').html()!='+ New Section' ){
					$('#helppage_section_sel_chzn .chzn-single span').html('<span>Select...</span>');
					$('#helppage_section_sel_chzn li').removeClass('result-selected');
					$('#helppage_section_sel').val('');
					$('#helppage_section').val('');
				}
	 
	 
	 }
	 
	 
 		$().ready(function() {
			
			
			funcpages($('#book_region_id').val(),0);
			
			$('#book_region_id').change(function(){
				funcpages($(this).val(),1);
			});
			
			$('#helppage_section-sel').change(function(){
				
					$('#helppage_section_new').css('display','none');
					$('#helppage_section_status_new').css('display','none');
				
				if($(this).val() == 'new'){
					$('#helppage_section_new').css('display','block');
					$('#helppage_section_status_new').css('display','block');
					$('#helppage_section').val('');
					$('#helppage_section_status').val('DRAFT');
					
				 } else if($(this).val() != ''){
				 	var array  = $(this).val().split('||');
					$('#helppage_section').val($(this).val());
					$('#helppage_section_status').val(array[2]);
					
				 }
					 
			});
		
		
		$('#helppage_template_id').change(function(){
				$('#imagesizes').html('Image Upload<br>');
				if($(this).val()=='3'){
					$('#imagesizes').html('Image Upload<br>(w 1024 x h 298px)');
					
					$('#templateIcon img').attr('src','img/top-image.png');
					$('#templateIcon img').css('display','block');
					
				} else if($(this).val()=='1' || $(this).val()=='2'){
					
					if($(this).val()=='1'){
						$('#templateIcon img').attr('src','img/right-image.png');
						$('#templateIcon img').css('display','block');
					} else{
						$('#templateIcon img').attr('src','img/left-image.png');
						$('#templateIcon img').css('display','block');
					}
					
					$('#imagesizes').html('Image Upload<br>(w 414 x h 715px)');
				}
			});
			
			$('#helppage_template_id').val($('#helppage_template_id').val()).change();
			// validate the comment form when it is submitted
		
				var formvals = 'helppage_template_id,helppage_title,book_region_id,helppage_content,helppage_section';
			
			$('#submit').click(function(){
				return formvalid(formvals);
			});
			
			$("input[type='text'],select,textarea").change(function(){
				if($('.error-k').length > 0){
					formvalid(formvals);
				}
			});
			
			$("input[type='text'],select,textarea").focus(function(){
				if($('.error-k').length > 0){
					formvalid(formvals);
				}
			});
			$("input[type='text'],select,textarea").blur(function(){
				if($('.error-k').length > 0){
					formvalid(formvals);
				}
			});
			
			
			
		 });
		 
		 


       $(function() {

           $.configureBoxes();

       });

   </script>
   <script>
   
       $(function () {
           $(" input[type=radio], input[type=checkbox]").uniform();
       });
   </script>

</body>
<!-- END BODY -->
</html>