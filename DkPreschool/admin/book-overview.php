<?
 require('config/config.php'); 
 	// ### set default data filter criteria here
	$searchStr = '';
	$colsArray = array('book_auto_id','book_title','readerlevel_name','region_code','book_dateadded','book_publication_date','book_status');
 	// ### get records for page
 	$sql = 'CALL funcGetRecords(\'books\',\''.implode(',',$colsArray).'\',\''.$searchStr.'\',\'0\','.$_SESSION['login_region'].')';
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
                      <input name="keyword" type="text" class="search-query" placeholder="Search" />
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
<div class="widget blue">

<div class="widget-title">
<h4><i class="icon-reorder"></i> Books</h4>
<span class="tools"><a href="javascript:;" class="icon-chevron-down"></a></span>
</div>

<div class="widget-body">
<div>

<div class="clearfix">
  <div class="btn-group">
  <a href="book-overview-add.php"><button id="" class="btn green">Add New <i class="icon-plus"></i></button></a>
  </div>
  <!--div class="btn-group pull-right">
  <button class="btn dropdown-toggle" data-toggle="dropdown">Tools <i class="icon-angle-down"></i></button>
    <ul class="dropdown-menu pull-right">
      <li><a href="#">Print</a></li>
      <li><a href="#">Save as PDF</a></li>
      <li><a href="#">Export to Excel</a></li>
    </ul>
  </div-->
</div>

<div class="space15"></div>
<table class="table table-striped table-hover table-bordered" id="editable-sample">
<thead>
<tr>
<th>Book Title</th>
<th width="10%">Reader Level</th>
<th width="7%">Region</th>
<th width="5%">Pub Date</th>
<th width="15%">Status</th>
<th width="3%"></th>
</tr>
</thead>
<tbody>
<? 	foreach  ($dcArray as $record) { ?>
	<tr class="">
		<td><?=$record['book_title']?></td>
		<td><?=$record['readerlevel_name']?></td>
		<td><?=$record['region_code']?></td>
		<td class="center"><?=date("d/m/Y",strtotime($record['book_publication_date']))?></td>
		<td><?=$record['book_status']?></td>
        <td><a href="book-overview-edit.php?id=<?=$record['book_auto_id']?>">Edit</a></td>
	</tr>
<? } ?>
</tbody>
</table>



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


   <!--common script for all pages-->
   <script src="js/common-scripts.js"></script>

   <!-- END JAVASCRIPTS -->
   <script>
     jQuery.extend( jQuery.fn.dataTableExt.oSort, {
			"date-uk-pre": function ( a ) {
					
				var ukDatea = a.split('/');
				if(ukDatea.length>1){
					return (ukDatea[2] + ukDatea[1] + ukDatea[0]) * 1;
				} else {
					return 'blank';
				}
			},
		 
			"date-uk-asc": function ( a, b ) {
				
				if(a=='blank'){
					a=300000101;
				}
				if(b=='blank'){
					b=300000101;
				}
				
				return ((a < b) ? -1 : ((a > b) ? 1 : 0));
			},
		 
			"date-uk-desc": function ( a, b ) {
				if(a=='blank'){
					a=19000101;
				}
				if(b=='blank'){
					b=19000101;
				}
				return ((a < b) ? 1 : ((a > b) ? -1 : 0));
			}
		} );
   
       jQuery(document).ready(function() {
	   var oTable = $('#editable-sample').dataTable({
                "aLengthMenu": [
                    [5, 15, 20, -1],
                    [5, 15, 20, "All"] // change per page values here
                ],
                // set the initial value
                "iDisplayLength": 20,
                "sDom": "<'row-fluid'<'span6'l><'span6'f>r>t<'row-fluid'<'span6'i><'span6'p>>",
                "sPaginationType": "bootstrap",
                "oLanguage": {
                    "sLengthMenu": "_MENU_ records per page",
                    "oPaginate": {
                        "sPrevious": "Prev",
                        "sNext": "Next"
                    }
                },
                "aoColumnDefs": [{
                        'bSortable': false,
                        'aTargets': [-1]
                    },
					{
						'bSortable': true,
						'sType': 'date-uk',
						'aTargets': [-3]
					}
                ]
            })
       });
   </script>
</body>
<!-- END BODY -->
</html>