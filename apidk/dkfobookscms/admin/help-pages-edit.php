<?
 require('config/config.php');
 require('config/misc.php'); 
 require('config/upload.php');
 
 	$promoCols = array('helppage_title','helppage_image','helppage_template_id','book_region_id','helppage_section_guid','helppage_section','helppage_section_status','helppage_status','helppage_content');
 
  // ### set default data filter criteria here
	$searchStr = '';
	$colsArray = array('helppage_title','helppage_auto_id','helppage_section_guid','region_code','helppage_section','helppage_section_status','helppage_region_id','helppage_order','helppage_status');
 	// ### get records for page
 	$sql = 'CALL funcGetRecords(\'helpsub\',\''.implode(',',$colsArray).'\',\''.addslashes($searchStr).'\',\''.$_REQUEST['id'].'\','.$_REQUEST['rid'].')';
	$mysqli = connectMySqli();
	$result = $mysqli->query($sql);
	$recordcount = 0;
	$dcArray = array();
	
	if($result){
	 while ($row = $result->fetch_object()) {
        $dcArray[$recordcount] = array();
		foreach ($colsArray as $cols) {
			// ### get col name save data to array
			$dcArray[$recordcount][$cols] = $row->$cols;
		}
		$recordcount++;
	 }
	}
 

 if($_POST['helppage_section']){
 // ### save help section

	$sql ='CALL funcSaveHelpSection(\'save\',\''.addslashes($_POST['helppage_section']).'\',\''.$_POST['helppage_section_status'].'\',\''.$_REQUEST['id'].'\')';
	$mysqli = connectMySqli();
	$result = $mysqli->query($sql);

	header('location:help-pages.php');
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
<style>
.ui-sortable tr:hover{
	cursor:pointer;
}
.ui-sortable-helper{
display:table;
cursor:move !important;
opacity:0.5;
}

</style>


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

<div class="row-fluid">
<div class="span12">
<!-- BEGIN widget-->
<!-- BEGIN EXAMPLE TABLE widget-->
<div class="widget black">

<div class="widget-title">
<h4><i class="icon-reorder"></i>Help Sub Pages - (<?=$_REQUEST['sect'] ?>)</h4>
<span class="tools"><a href="javascript:;" class="icon-chevron-down"></a></span>
</div>


<div class="widget-body">
<div>

<div class="clearfix">
  <div class="btn-group pull-left">
  <a href="help-pages-add.php?sect=<?=$_REQUEST['sect']?>&id=<?=$_REQUEST['id']?>&rid=<?=$_REQUEST['rid']?>&r=e"><button id="" class="btn green">Add New <i class="icon-plus"></i></button></a>
  </div>
<div class="pull-left" style="margin-left:15px;line-height:30px;"><i> * drag table rows to order data</i></div>
</div>
<div class="space15"></div>
									<table class="table table-striped table-hover table-bordered dragtable-sample" id="dragtable-sample">
											 <thead>
											 <tr>
												 <th>Title</th>
												 <th>Help Section</th>
												 <th width="5%">Region</th>
												 <th width="15%">Status</th>
												 <th width="3%"></th>
                                                 <th width="2%"></th>
											 </tr>
											 </thead>
											 <tbody>
										   <? foreach  ($dcArray as $record) {  ?>
                                            <tr id="helpsub_<?=$record['helppage_auto_id']?>">
                                                    <td><?=$record['helppage_title']?></td>
                                                    <td><?=$record['helppage_section']?></td>
                                                    <td><?=$record['region_code']?></td>
                                                    <td><?=$record['helppage_status']?></td>
                                                    <td><a href="help-pages-sub-pages-edit.php?sid=<?=$record['helppage_auto_id']?>&sect=<?=$record['helppage_section']?>&id=<?=$record['helppage_section_guid']?>&rid=<?=$record['helppage_region_id']?>&sub=1">Edit</a></td>
                                                    <td><a href="#" onclick="<?='funcDelete(\'helpsub\',\''.$record['helppage_auto_id'].'\',\''.$record['helppage_title'].'\');return false'?>"><i class="icon-trash" style="font-size:18px"></i></a></td>
                                                </tr>
                                          <? } ?>
								</tbody></table>      
                         </div>
</div>
</div>
<!-- END EXAMPLE TABLE widget-->

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
<form action="" method="post" id="helppageForm" enctype="multipart/form-data" class="cmxform form-horizontal" >
<!-- BEGIN FORM-->

<?
// ## if master show this option else use users loggedin region 
// get reigons from database
	$searchStr = "";
	$rid = $_SESSION['login_region'];
	
	
	$colsArray = array('helppage_section_guid','helppage_section','helppage_section_status','helppage_section_order','helppage_region_id');
 	$sql = 'CALL funcGetRecords(\'helpmain\',\''.implode(',',$colsArray).'\',\''.$searchStr.'\',\''.$_REQUEST['id'].'\','. $_SESSION['login_region'].')';
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


    <div class="control-group">
    <label for="helppage_section" class="control-label">Section Title</label>
        <div class="controls">
            <div id="helppage_section-e" class="span4"><div class="icon-exclamation-sign"></div>
            <input id="helppage_section" name="helppage_section" type="text"  style="width:95%" maxlength="220" value="<?=$sectionArray[0]['helppage_section']?>"/>
            </div>
        </div>
    </div>

    <div class="control-group">
        <label class="control-label">Section Status</label>
            <div class="controls">
                <div class="span4">
                    <select id="helppage_section_status" name="helppage_section_status" class="chzn-select" tabindex="1">
                    <option value="DRAFT" <?=$sectionArray[0]['helppage_section_status'] == 'DRAFT' ? 'selected' : ''?>>Draft</option>
                    <option value="LIVE" <?=$sectionArray[0]['helppage_section_status'] == 'LIVE' ? 'selected' : ''?>>Live</option>
                    </select>
                </div>
            </div>
    </div>


<button type="submit" id="submit" class="btn btn-success">Save</button>
<button type="button" class="btn" onclick="window.location='help-pages.php'">Cancel</button>


</form>


<!-- END FORM-->

</div></div>

<!-- END widget-->
</div>
</div>


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
   <script src="js/drag-table.js"></script>
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
			
			// validate the comment form when it is submitted
		
				var formvals = 'helppage_section';
			
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
           DragTable.init();
      
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