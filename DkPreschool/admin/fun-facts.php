<?
 require('config/config.php'); 
 
 // ### set default data filter criteria here
	$searchStr = '';
	$colsArray = array('funfact_auto_id','funfact_title','region_code','funfact_status','funfact_region_id','funfact_order');
 	// ### get records for page
 	$sql = 'CALL funcGetRecords(\'funfacts\',\''.implode(',',$colsArray).'\',\''.$searchStr.'\',\'0\','.$_SESSION['login_region'].')';
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
 //echo $sql;
 
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
<link rel="stylesheet" href="assets/data-tables/DT_bootstrap.css" />
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
<div id="header" class="navbar navbar-inverse navbar-fixed-top">
<!-- BEGIN TOP NAVIGATION BAR -->
<div class="navbar-inner">
<div class="container-fluid">
<!--BEGIN SIDEBAR TOGGLE-->
<div class="sidebar-toggle-box hidden-phone">
<div class="icon-reorder tooltips" data-placement="right" data-original-title="Toggle Navigation"></div>
</div>
<!--END SIDEBAR TOGGLE-->

<!-- BEGIN LOGO -->
<a class="brand" href="index.html">
<img src="img/logo.png" alt="DK Readers" />
</a>
<!-- END LOGO -->

<!-- BEGIN RESPONSIVE MENU TOGGLER -->
  <a class="btn btn-navbar collapsed" id="main_menu_trigger" data-toggle="collapse" data-target=".nav-collapse">
  <span class="icon-bar"></span>
  <span class="icon-bar"></span>
  <span class="icon-bar"></span>
  <span class="arrow"></span>
</a>
<!-- END RESPONSIVE MENU TOGGLER --><!-- END  NOTIFICATION -->

  <div class="top-nav "><!-- END TOP NAVIGATION MENU -->


</div>
</div>
</div>
<!-- END TOP NAVIGATION BAR -->

</div>
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
<div class="row-fluid">

<!--BEGIN METRO STATES-->
<!-- BEGIN EDITABLE TABLE widget-->
             <div class="row-fluid">
                 <div class="span12">
                     <!-- BEGIN EXAMPLE TABLE widget-->
                     <div class="widget yellow">
                         <div class="widget-title">
                             <h4><i class="icon-reorder"></i> Fun Facts</h4>
                            <span class="tools">
                                <a href="javascript:;" class="icon-chevron-down"></a>
                            </span>
                         </div>
                         <div class="widget-body">
                             <div>
                                 <div class="clearfix">
                                     <div class="btn-group pull-left">
                                         <a href="fun-facts-add.php"><button id="" class="btn green">
                                             Add New <i class="icon-plus">
                                            </i>
                                         </button></a>
                                     </div><div class="pull-left" style="margin-left:15px;line-height:30px;"><i> * drag table rows to order data</i></div>
                                 </div>
                                 <div class="space15"></div>
                                   <? $regionID='';
								   		$i =0;
								   foreach  ($dcArray as $record) { 
                                   if($regionID != $record['funfact_region_id']){
									  
									   if($i>0){ 
									  	 echo '</tbody></table><br/>';
									   }
									   
									   if($_SESSION['login_region']==0){
										   // ### add region header if master login
									  	 echo '<h4>'.$record['region_code'].' Fun Facts</h4>';
									   }
									   
									   echo '<table class="table table-striped table-hover table-bordered dragtable-sample" id="dragtable-sample'.$i.'">
											 <thead>
											 <tr>
												 <th>Title</th>
												 <th width="5%">Region</th>
												 <th width="15%">Status</th>
												 <th width="3%"></th>
												 <th width="2%"></th>
											 </tr>
											 </thead>
											 <tbody>';
											 $regionID =  $record['funfact_region_id'];		
								   }
										 
									 ?>
                                     <?
								
									 
                                     echo  '<tr id="funfact_'.$record['funfact_auto_id'].'">
                                            <td>'.$record['funfact_title'].'</td>
                                            <td>'.$record['region_code'].'</td>
                                            <td>'.$record['funfact_status'].'</td>
                                            <td><a href="fun-facts-edit.php?id='.$record['funfact_auto_id'].'">Edit</a></td>
											<td><a href="#" onclick="funcDelete(\'funfact\',\''.$record['funfact_auto_id'].'\',\''.$record['funfact_title'].'\');return false"><i class="icon-trash" style="font-size:18px"></i></a></td></tr>';
								   $i++;
								   }
                                   ?>
									<?
                                 if($i>0){ 
                                	     echo '</tbody></table><br/>';
                                  	 }
                                	?>        
                             </div>
                         </div>
                     </div>
                     <!-- END EXAMPLE TABLE widget-->
<!--END METRO STATES-->



</div>
</div>
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
   <script src="js/jquery-1.8.3.min.js"></script>
   <script src="js/jquery.nicescroll.js" type="text/javascript"></script>
   <script src="assets/bootstrap/js/bootstrap.min.js"></script>
   <script src="js/jquery.blockui.js"></script>
   <!-- ie8 fixes -->
   <!--[if lt IE 9]>
   <script src="js/excanvas.js"></script>
   <script src="js/respond.js"></script>
   <![endif]-->
   <script type="text/javascript" src="assets/uniform/jquery.uniform.min.js"></script>
   <script type="text/javascript" src="assets/data-tables/jquery.dataTables.js"></script>
   <script type="text/javascript" src="assets/data-tables/DT_bootstrap.js"></script>
   <script src="js/jquery.scrollTo.min.js"></script>
   <script src="assets/jquery-slimscroll/jquery.slimscroll.min.js"></script>
   <script src="js/jquery-ui-1.10.3.custom.min.js"></script>
   <script src="js/jquery.dataTables.rowReordering.js"></script>


   <!--common script for all pages-->
   <script src="js/common-scripts.js"></script>

   <!--script for this page only-->
   <script src="js/drag-table.js"></script>

   <!-- END JAVASCRIPTS -->
      <script>
       jQuery(document).ready(function() {
           DragTable.init();
       });
   </script>
</body>
<!-- END BODY -->
</html>