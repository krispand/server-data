<?
 require('config/config.php'); 
 

  	// ### get dashboard totals from database
	$sql= 'CALL funcDashBoardTotals('.$_SESSION['login_region'].')';
	$mysqli = connectMySqli();
	$result = $mysqli->query($sql);
	$dashboard = array();
	if($result){
		$row = $result->fetch_object();
		$dashboard['book_total'] = $row->book_total;
		$dashboard['promo_total'] = $row->promo_total;
		$dashboard['funfacts_total'] = $row->funfacts_total;
		$dashboard['helppages_total'] = $row->helppages_total;
	} else{
		$dashboard['book_total'] = 0;
		$dashboard['promo_total'] = 0;
		$dashboard['funfacts_total'] = 0;
		$dashboard['helppages_total'] = 0;	
	}
	$mysqli->close();
 

 
?>
<!DOCTYPE html>
<!--[if IE 8]> <html lang="en" class="ie8"> <![endif]-->
<!--[if IE 9]> <html lang="en" class="ie9"> <![endif]-->
<!--[if !IE]><!--> <html lang="en"> <!--<![endif]-->
<!-- BEGIN HEAD -->
<head>
<meta charset="utf-8" />
<title>Dashboard</title>
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
                   <h3 class="page-title">
                     Dashboard
                   </h3>
                   <!-- END PAGE TITLE & BREADCRUMB-->
               </div>
            </div>
<!-- END PAGE HEADER-->


<!-- BEGIN PAGE CONTENT-->
<div class="row-fluid">

<!--BEGIN METRO STATES-->
<div class="metro-nav">

<div class="metro-nav-block nav-light-blue double">
<a data-original-title="" href="book-overview.php">
<i class="icon-shopping-cart"></i>
<div class="info"><?=$dashboard['book_total']?></div>
<div class="status">Book Overview</div>
</a>
</div>

<div class="metro-nav-block nav-block-red">
<a data-original-title="" href="promotion-overview.php">
<i class="icon-tags"></i>
<div class="info"><?=$dashboard['promo_total']?></div>
<div class="status">Promo Overview</div>
</a>
</div>

<div class="metro-nav-block nav-block-yellow">
<a data-original-title="" href="fun-facts.php">
<i class="icon-smile"></i>
<div class="info"><?=$dashboard['funfacts_total']?></div>
<div class="status">Fun Facts Overview</div>
</a>
</div>

<div class="metro-nav-block nav-block-green">
<a data-original-title="" href="help-pages.php">
<i class="icon-heart"></i>
<div class="info"><?=$dashboard['helppages_total']?></div>
<div class="status">Help Pages</div>
</a>
</div>

</div>

 <div class="space10"></div>
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
   <script src="js/jquery.scrollTo.min.js"></script>

   <!-- ie8 fixes -->
   <!--[if lt IE 9]>
   <script src="js/excanvas.js"></script>
   <script src="js/respond.js"></script>
   <![endif]-->

   <!--common script for all pages-->
   <script src="js/common-scripts.js"></script>

   <!-- END JAVASCRIPTS -->   
</body>
<!-- END BODY -->
</html>