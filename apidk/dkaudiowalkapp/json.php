<?php
header('content-type: application/json; charset=utf-8');error_reporting(0);
header("access-control-allow-origin: *");
include "includes/data.php";
//echo count($dictionaryArray);
$task ='';
$task =  $_GET["id"];
$env =  $_GET["env"];
$plat =  $_GET["plat"];

if($plat=='android')
{
	if($env=='testing')
	{
		if($task == 'dbversion')
		{
			echo '1.3';
		}
		else 
		{
			//$_GET['callback'] . '('.json_encode($dictionaryArraytestAndroid).')';
			echo json_encode($cityArraytestAndroid);
		}
	}
	else
	{
		if($task == 'dbversion')
		{
			echo '1.0';
		}
		else 
		{
			echo json_encode($cityArrayAndroid);
		}
	}
}
else
{
	if($env=='testing')
	{
		if($task == 'dbversion')
		{
			echo '1.4';
		}
		else 
		{
			echo json_encode($cityArraytest);
		}
	}
	else
	{
		if($task == 'dbversion')
		{
			echo '1.0';
		}
		else 
		{
			echo json_encode($cityArray);
		}
	}
}
?>