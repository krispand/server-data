 <?
 $strBasename = basename($_SERVER['PHP_SELF']);
 
  if($_REQUEST['sub']=='1'){
	  // edit sub page
	   $strBasename = str_replace('help-pages','help',$strBasename);
  }
 
 $pagetitle = ucwords(strtolower(str_replace('.php','',str_replace('-',' ',$strBasename))));
 ?>
<h3 class="page-title">
 <? 
 if(is_numeric(strpos($strBasename,'-add'))===true || is_numeric(strpos($strBasename,'-edit'))===true){
		 echo str_replace(str_replace(' Add','',str_replace(' Edit','',$pagetitle)),'',$pagetitle). ' '.str_replace('Overview','',str_replace(' Add','',str_replace(' Edit','',$pagetitle)));
	 } else {
		echo $pagetitle;
	} 
	
	
?>
</h3>
<ul class="breadcrumb">
<? if($_REQUEST['sub']=='1'){ ?>
	<li>
       <a href="index.php">Dashboard</a>
       <span class="divider">/</span>  
   </li>
   
   <li>
      <a href="help-pages.php">Help Pages</a>
       <span class="divider">/</span>  
   </li>
    <li class="active">
      	<a href="help-pages-edit.php?sect=<?=$_REQUEST['sect']?>&id=<?=$_REQUEST['id']?>&rid=<?=$_REQUEST['rid']?>"><?=str_replace(' Add','',str_replace(' Edit','',$pagetitle))?></a>
        <span class="divider">/</span>  
   	</li> 
      <li class="active">
      	<?=str_replace(str_replace(' Add','',str_replace(' Edit','',$pagetitle)),'',$pagetitle)?> <?=str_replace('Overview','',str_replace(' Add','',str_replace(' Edit','',$pagetitle)))?>
   	 </li>
         
   
<? } else {?>
    <li>
       <a href="index.php">Dashboard</a>
       <span class="divider">/</span>  
   </li>
   
    <? if(is_numeric(strpos($strBasename,'-add'))===true || is_numeric(strpos($strBasename,'-edit'))===true){?>
    <li class="active">
      	<a href="<?= str_replace('-add','',str_replace('-edit','',$strBasename))?>"><?=str_replace(' Add','',str_replace(' Edit','',$pagetitle))?></a>
        <span class="divider">/</span>  
   	</li> 
      <li class="active">
      	<?=str_replace(str_replace(' Add','',str_replace(' Edit','',$pagetitle)),'',$pagetitle)?> <?=str_replace('Overview','',str_replace(' Add','',str_replace(' Edit','',$pagetitle)))?>
   	 </li>
   
   
    <? } else{ ?>
      <li class="active">
      	<?=$pagetitle?>
   	 </li>
    <? } ?>
   <? } ?>
</ul>
