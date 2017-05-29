<?
 require('config/config.php'); 

if(strlen($_POST['username']) > 0 && strlen($_POST['password']) > 0 ){ 
	// ### check login details again the database 
 	$err = '';	
	$sql = 'CALL funcLogin(\''.$_POST['username'].'\',\''.md5($_POST['password']).'\')';
	$mysqli = connectMySqli();
	$result = $mysqli->query($sql);

	
	if($result){
		$row = $result->fetch_object();
		
		if($row->user_username){
			
			if($_REQUEST['remember'] == '1'){
				// ### remember user for 2 hours
				$hour = time() + (3600*2);
				setcookie('login_username', $row->user_username, $hour);
				setcookie('login_region', $row->user_region_id, $hour);
			}
			
			$_SESSION['login_username'] = $row->user_username;
			$_SESSION['login_region'] = $row->user_region_id;
			header('location:index.php');
			// ### login successful open dashboard
			
		} else{
			// ### login error failed
			$err = '* Login Failed';
		}
	} else{
		// ### login error failed
		$err = '* Login Failed';
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
   <title>Login</title>
   <meta content="width=device-width, initial-scale=1.0" name="viewport" />
   <meta content="" name="description" />
   <meta content="" name="author" />
   <link href="assets/bootstrap/css/bootstrap.min.css" rel="stylesheet" />
   <link href="assets/bootstrap/css/bootstrap-responsive.min.css" rel="stylesheet" />
   <link href="assets/font-awesome/css/font-awesome.css" rel="stylesheet" />
   <link href="css/style.css" rel="stylesheet" />
   <link href="css/style-responsive.css" rel="stylesheet" />
   <link href="css/style-default.css" rel="stylesheet" id="style_color" />
</head>
<!-- END HEAD -->
<!-- BEGIN BODY -->
<body class="lock">
 <form action="login.php" method="post">
    <div class="lock-header">
        <!-- BEGIN LOGO -->
        <a class="center" id="logo" href="index.php">
            <img class="center" alt="logo" src="img/logo.png">
        </a>
        <!-- END LOGO -->
    </div>
    <div class="login-wrap">
        <div class="metro single-size red">
            <div class="locked">
                <i class="icon-lock"></i>
                <span>Login</span>
            </div>
        </div>
     
        <div class="metro double-size green">
        
                <div class="input-append lock-input">
                    <input name="username" type="text" value="<?=$_POST['username']?>" class="" id="username" placeholder="Username">
                </div>
           
        </div>
        <div class="metro double-size yellow">
        
                <div class="input-append lock-input">
                    <input name="password" type="password" value="<?=$_POST['password']?>" class="" placeholder="Password">
                </div>
        	
        </div>
        <div class="metro single-size terques login">
         
                <button type="submit" class="btn login-btn">
                    Login
                    <i class=" icon-long-arrow-right"></i>
                </button>
          
        </div>
  
        <div class="login-footer">
            <div class="remember-hint pull-left">
                <input name="remember" type="checkbox" id="" value="1"> Remember Me
            </div>
            <div class="pull-left" style="padding-left:15px;font-size:16px;width:200px;font-weight:bold;"><?=$err?></div> 
            <div class="forgot-hint pull-right">
                <a id="forget-password" class="" href="javascript:alert('Contact info@kokodigital.co.uk\nregarding access to this site');">Forgot Password?</a>
            </div>
        </div>
    </div>
       </form>
</body>
<!-- END BODY -->
</html>