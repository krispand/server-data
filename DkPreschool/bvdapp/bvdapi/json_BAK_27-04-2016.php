<?php
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
			echo json_encode($dictionaryArraytestAndroid);
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
			echo json_encode($dictionaryArrayAndroid);
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
			echo json_encode($dictionaryArraytest);
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
			echo json_encode($dictionaryArray);
		}
	}
}
?>