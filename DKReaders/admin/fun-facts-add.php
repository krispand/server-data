<?
 require('config/config.php');
 require('config/misc.php'); 
 require('config/upload.php');
 

 
 $promoCols = array('funfact_title','funfact_image','book_region_id','funfact_startdate','funfact_enddate','funfact_status');

 
 if($_POST['funfact_title']){
 // ### Start insert of record

	
	$arraydate = explode(' to ',$_POST['funfact_daterange']);
	$startdate = $arraydate[0] ;
	$enddate= $arraydate[1];
		

 	if ($_FILES['funfact_image']['tmp_name']!=''){
			// ### upload image
			$imagePath = '../assets/funfacts/';
			$imagename = GetCleanFileName(preg_replace("/[^A-Za-z0-9 ]/", '',$_POST['funfact_title']));
			$imagename = GetFileUnique($imagePath,$imagename,substr(strrchr($_FILES['funfact_image']['name'],'.'),0));
			uploadfile('image','funfact_image',$imagename,$imagePath,496,328);
			$imagename = $imagename.substr(strrchr($_FILES['funfact_image']['name'],'.'),0);	
	}

	 
	 $sql ='CALL funcSaveFunFact(\'add\',\''.addslashes($_POST['funfact_title']).'\',\''.$imagename.'\','.intNull($_POST['book_region_id'],1).',\''.strToDBDate($startdate).'\',\''.strToDBDate($enddate).'\',\''.$_POST['funfact_status'].'\',0)';
	 
	$mysqli = connectMySqli();
	$result = $mysqli->query($sql);

	header('location:fun-facts.php');
	
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
<form action="" method="post" id="funfactForm" enctype="multipart/form-data" class="cmxform form-horizontal" >

<div class="row-fluid">
<div class="span12">

<!-- BEGIN widget-->
<div class="widget yellow">
      <div class="widget-title"><h4><i class="icon-reorder"></i> New Fun Fact</h4>
      <span class="tools">
      <a href="javascript:;" class="icon-chevron-down"></a>

      </span>
      </div>


<div class="widget-body">
<!-- BEGIN FORM-->


<div class="control-group">
<label for="funfact_title" class="control-label">Fun Fact Title</label>
<div class="controls">
	<div id="funfact_title-e" class="span4"><div class="icon-exclamation-sign"></div>
	<input id="funfact_title" name="funfact_title" type="text"  style="width:95%" maxlength="220"/>
   
    </div>
</div></div>

<div class="control-group">
<label for="funfact_image" class="control-label">Image Upload<br>
(w 496 x h 328px)</label>
<div class="controls">
<div data-provides="fileupload" class="fileupload fileupload-new" data-name="funfact-image" required>
<div style="width: 200px; height: 150px;" class="fileupload-new thumbnail"><img alt="" src="http://www.placehold.it/200x150/EFEFEF/AAAAAA&amp;text=no+image"></div>
<div style="max-width: 200px; max-height: 150px; line-height: 20px;" class="fileupload-preview fileupload-exists thumbnail"></div>
<div><span class="btn btn-file"><span class="fileupload-new">Select image</span><span class="fileupload-exists">Change</span>
<input type="file" id="funfact_image" name="funfact_image" class="default"></span><a data-dismiss="fileupload" class="btn fileupload-exists" href="#">Remove</a></div>
</div></div></div>



<? if (intval($_SESSION['login_region']) == 0){ 
// ## if master show this option else use users loggedin region 
// get reigons from database
	$searchStr = "";
	$colsArray = array('region_auto_id','region_name','region_code');
 	$sql = 'CALL funcGetRecords(\'regions\',\''.implode(',',$colsArray).'\',\''.$searchStr.'\',\'0\','.$_SESSION['login_region'].')';
	$mysqli = connectMySqli();
	$result = $mysqli->query($sql);
	$recordcount = 0;
	$regionArray = array();
	
	if($result){
	 while ($row = $result->fetch_object()) {
        $regionArray[$recordcount] = array();
		foreach ($colsArray as $cols) {
			// ### get col name save data to array
			$regionArray[$recordcount][$cols] = $row->$cols;
		}
		$recordcount++;
	 }
	}

?>

<div class="control-group">
<label for="book_region_id" class="control-label">Region</label>
<div class="controls">
	<div class="span4" id="book_region_id-e"><div class="icon-exclamation-sign"></div>
<select name="book_region_id" id="book_region_id" class="chzn-select" data-placeholder="Select Region" tabindex="1">
	<option value="">Select...</option>
	<? 	foreach  ($regionArray as $record) { ?>
    <option value="<?=$record['region_auto_id']?>"><?=$record['region_code']?></option>
    <? }?>
</select>
	</div>
</div></div>
<? } else {?>
<input name="book_region_id" type="hidden" value="<?=$_SESSION['login_region']?>" />
<? }?>

<div class="control-group">
<label for="funfact_daterange" class="control-label">Fun Fact Start/End Date</label>
<div class="controls">
<div id="funfact_daterange-e"><div class="icon-exclamation-sign"></div>
<div class="input-prepend">
<span class="add-on"><i class="icon-calendar"></i></span>
<input id="funfact_daterange" name="funfact_daterange" type="text" class=" m-ctrl-medium " value=""/>
</div>
</div>
</div>
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

<div class="control-group">

<label class="control-label">Fun Fact Status</label>
<div class="controls">
<div class="span4">
<select name="funfact_status" class="chzn-select" tabindex="1">
<option value="DRAFT">Draft</option>
<option value="LIVE">Live</option>
</select>
</div></div>
</div>


<button type="submit" id="submit" class="btn btn-success">Save</button>
<button type="button" class="btn" onclick="window.location='fun-facts.php'">Cancel</button>





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
	 
 		$().ready(function() {
			// validate the comment form when it is submitted
		
			
			var formvals = 'funfact_daterange,book_region_id,funfact_title';
			
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