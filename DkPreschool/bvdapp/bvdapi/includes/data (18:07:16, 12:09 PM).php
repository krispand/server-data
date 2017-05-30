<?php
//$apiVersion =array("dbversion"=>"1.0");
// $dictionaryArray = array("dbversion"=>"1.0","overwritedb"=>"0","databasearray"=>array(array("orderId"=>"1","Dictionary"=>"English German","ImageName"=>"images/1_Cover.png","BarCodeImage"=>"barcode/1_Barcode.png","Languages"=>"German,English","BarCode"=>"9783831029679","DbPath"=>"datafiles/1_BVDTemplate.sqlite"),
							// array("orderId"=>"2","Dictionary"=>"German","ImageName"=>"images/2_Cover.png","BarCodeImage"=>"barcode/2_Barcode.png","Languages"=>"German","BarCode"=>"9783831029662","DbPath"=>"datafiles/2_BVDTemplate.sqlite"),
							// array("orderId"=>"3","Dictionary"=>"Arabic German","ImageName"=>"images/3_Cover.png","BarCodeImage"=>"barcode/3_Barcode.png","Languages"=>"German,Arabic","BarCode"=>"9783831029624","DbPath"=>"datafiles/3_BVDTemplate.sqlite"),
							// array("orderId"=>"4","Dictionary"=>"French German","ImageName"=>"images/4_Cover.png","BarCodeImage"=>"barcode/4_Barcode.png","Languages"=>"German,French","BarCode"=>"9783831029686","DbPath"=>"datafiles/4_BVDTemplate.sqlite"),
							// array("orderId"=>"5","Dictionary"=>"Italian German","ImageName"=>"images/5_Cover.png","BarCodeImage"=>"barcode/5_Barcode.png","Languages"=>"German,Italian","BarCode"=>"9783831029716","DbPath"=>"datafiles/5_BVDTemplate.sqlite"),
							// array("orderId"=>"6","Dictionary"=>"Spanish German","ImageName"=>"images/6_Cover.png","BarCodeImage"=>"barcode/6_Barcode.png","Languages"=>"German,Spanish","BarCode"=>"9783831029822","DbPath"=>"datafiles/6_BVDTemplate.sqlite")));
$dictionaryArray = array("dbversion"=>"1.0","overwritedb"=>"0","databasearray"=>array(array("orderId"=>"1","Dictionary"=>"English German","ImageName"=>"images/1_Cover.png","BarCodeImage"=>"barcode/1_Barcode.png","Languages"=>"German,English","BarCode"=>"9783831029679","DbPath"=>"datafiles/1_BVDTemplate.sqlite"),
							array("orderId"=>"2","Dictionary"=>"German","ImageName"=>"images/2_Cover.png","BarCodeImage"=>"barcode/2_Barcode.png","Languages"=>"German","BarCode"=>"9783831029662","DbPath"=>"datafiles/2_BVDTemplate.sqlite"),
							array("orderId"=>"5","Dictionary"=>"Italian German","ImageName"=>"images/5_Cover.png","BarCodeImage"=>"barcode/5_Barcode.png","Languages"=>"German,Italian","BarCode"=>"9783831029716","DbPath"=>"datafiles/5_BVDTemplate.sqlite"),
							array("orderId"=>"6","Dictionary"=>"Spanish German","ImageName"=>"images/6_Cover.png","BarCodeImage"=>"barcode/6_Barcode.png","Languages"=>"German,Spanish","BarCode"=>"9783831029822","DbPath"=>"datafiles/6_BVDTemplate.sqlite"),
							array("orderId"=>"4","Dictionary"=>"French German","ImageName"=>"images/4_Cover.png","BarCodeImage"=>"barcode/4_Barcode.png","Languages"=>"German,French","BarCode"=>"9783831029686","DbPath"=>"datafiles/4_BVDTemplate.sqlite"),
							array("orderId"=>"3","Dictionary"=>"Arabic German","ImageName"=>"images/3_Cover.png","BarCodeImage"=>"barcode/3_Barcode.png","Languages"=>"German,Arabic","BarCode"=>"9783831029624","DbPath"=>"datafiles/3_BVDTemplate.sqlite")));


// array("dbversion"=>"1.0","overwritedb"=>"0","databasearray"=>array(array("orderId"=>"1","Dictionary"=>"English German","ImageName"=>"images/1_Cover.png","BarCodeImage"=>"barcode/1_Barcode.png","Languages"=>"German,English","BarCode"=>"9783831029679","DbPath"=>"datafiles/1_BVDTemplate.sqlite"),
							// array("orderId"=>"2","Dictionary"=>"German","ImageName"=>"images/2_Cover.png","BarCodeImage"=>"barcode/2_Barcode.png","Languages"=>"German","BarCode"=>"9783831029662","DbPath"=>"datafiles/2_BVDTemplate.sqlite"),
							// array("orderId"=>"5","Dictionary"=>"Italian German","ImageName"=>"images/5_Cover.png","BarCodeImage"=>"barcode/5_Barcode.png","Languages"=>"German,Italian","BarCode"=>"9783831029716","DbPath"=>"datafiles/5_BVDTemplate.sqlite")));
							
$dictionaryArraytest = array("dbversion"=>"1.5","overwritedb"=>"0","databasearray"=>array(array("orderId"=>"1","Dictionary"=>"English German","ImageName"=>"images/1_Cover.png","BarCodeImage"=>"barcode/1_Barcode.png","Languages"=>"German,English","BarCode"=>"9783831029679","DbPath"=>"datafiles/1_BVDTemplate.sqlite"),
							array("orderId"=>"2","Dictionary"=>"German","ImageName"=>"images/2_Cover.png","BarCodeImage"=>"barcode/2_Barcode.png","Languages"=>"German","BarCode"=>"9783831029662","DbPath"=>"datafiles/2_BVDTemplate.sqlite"),
							array("orderId"=>"5","Dictionary"=>"Italian German","ImageName"=>"images/5_Cover.png","BarCodeImage"=>"barcode/5_Barcode.png","Languages"=>"German,Italian","BarCode"=>"9783831029716","DbPath"=>"datafiles/5_BVDTemplate.sqlite"),
							array("orderId"=>"6","Dictionary"=>"Spanish German","ImageName"=>"images/6_Cover.png","BarCodeImage"=>"barcode/6_Barcode.png","Languages"=>"German,Spanish","BarCode"=>"9783831029822","DbPath"=>"datafiles/6_BVDTemplate.sqlite"),
							array("orderId"=>"4","Dictionary"=>"French German","ImageName"=>"images/4_Cover.png","BarCodeImage"=>"barcode/4_Barcode.png","Languages"=>"German,French","BarCode"=>"9783831029686","DbPath"=>"datafiles/4_BVDTemplate.sqlite"),
							array("orderId"=>"3","Dictionary"=>"Arabic German","ImageName"=>"images/3_Cover.png","BarCodeImage"=>"barcode/3_Barcode.png","Languages"=>"German,Arabic","BarCode"=>"9783831029624","DbPath"=>"datafiles/3_BVDTemplate.sqlite"),
							array("orderId"=>"7","Dictionary"=>"Croatian German","ImageName"=>"images/7_Cover.png","BarCodeImage"=>"barcode/7_Barcode.png","Languages"=>"German,Croatian","BarCode"=>"9783831029730","DbPath"=>"datafiles/7_BVDTemplate.sqlite"),
							array("orderId"=>"8","Dictionary"=>"Turkish German","ImageName"=>"images/8_Cover.png","BarCodeImage"=>"barcode/8_Barcode.png","Languages"=>"German,Turkish","BarCode"=>"9783831029853","DbPath"=>"datafiles/8_BVDTemplate.sqlite"),
							array("orderId"=>"9","Dictionary"=>"Romanian German","ImageName"=>"images/9_Cover.png","BarCodeImage"=>"barcode/9_Barcode.png","Languages"=>"German,Romanian","BarCode"=>"9783831029792","DbPath"=>"datafiles/9_BVDTemplate.sqlite")));
							
							
$dictionaryArrayAndroid = array("dbversion"=>"1.0","overwritedb"=>"0","databasearray"=>array(array("orderId"=>"1","Dictionary"=>"English German","ImageName"=>"images/1_Cover.png","BarCodeImage"=>"barcode/1_Barcode.png","Languages"=>"German,English","BarCode"=>"9783831029679","DbPath"=>"xmlfiles/English_German.xml"),
							array("orderId"=>"2","Dictionary"=>"German","ImageName"=>"images/2_Cover.png","BarCodeImage"=>"barcode/2_Barcode.png","Languages"=>"German","BarCode"=>"9783831029662","DbPath"=>"xmlfiles/German.xml"),
							array("orderId"=>"5","Dictionary"=>"Italian German","ImageName"=>"images/5_Cover.png","BarCodeImage"=>"barcode/5_Barcode.png","Languages"=>"German,Italian","BarCode"=>"9783831029716","DbPath"=>"xmlfiles/Italian_German.xml"),
							array("orderId"=>"6","Dictionary"=>"Spanish German","ImageName"=>"images/6_Cover.png","BarCodeImage"=>"barcode/6_Barcode.png","Languages"=>"German,Spanish","BarCode"=>"9783831029822","DbPath"=>"xmlfiles/Spanish_German.xml"),
							array("orderId"=>"4","Dictionary"=>"French German","ImageName"=>"images/4_Cover.png","BarCodeImage"=>"barcode/4_Barcode.png","Languages"=>"German,French","BarCode"=>"9783831029686","DbPath"=>"xmlfiles/French_German.xml"),
							array("orderId"=>"3","Dictionary"=>"Arabic German","ImageName"=>"images/3_Cover.png","BarCodeImage"=>"barcode/3_Barcode.png","Languages"=>"German,Arabic","BarCode"=>"9783831029624","DbPath"=>"xmlfiles/Arabic_German.xml")));
// array("dbversion"=>"1.0","overwritedb"=>"0","databasearray"=>array(array("orderId"=>"1","Dictionary"=>"English German","ImageName"=>"images/1_Cover.png","BarCodeImage"=>"barcode/1_Barcode.png","Languages"=>"German,English","BarCode"=>"9783831029679","DbPath"=>"xmlfiles/English_German.xml"),
							// array("orderId"=>"2","Dictionary"=>"German","ImageName"=>"images/2_Cover.png","BarCodeImage"=>"barcode/2_Barcode.png","Languages"=>"German","BarCode"=>"9783831029662","DbPath"=>"xmlfiles/German.xml"),
							// array("orderId"=>"5","Dictionary"=>"Italian German","ImageName"=>"images/5_Cover.png","BarCodeImage"=>"barcode/5_Barcode.png","Languages"=>"German,Italian","BarCode"=>"9783831029716","DbPath"=>"xmlfiles/Italian_German.xml")));
							
							$dictionaryArraytestAndroid = array("dbversion"=>"1.3","overwritedb"=>"1","databasearray"=>array(array("orderId"=>"1","Dictionary"=>"English German","ImageName"=>"images/1_Cover.png","BarCodeImage"=>"barcode/1_Barcode.png","Languages"=>"German,English","BarCode"=>"9783831029679","DbPath"=>"xmlfiles/English_German.xml"),
							array("orderId"=>"2","Dictionary"=>"German","ImageName"=>"images/2_Cover.png","BarCodeImage"=>"barcode/2_Barcode.png","Languages"=>"German","BarCode"=>"9783831029662","DbPath"=>"xmlfiles/German.xml"),
							array("orderId"=>"5","Dictionary"=>"Italian German","ImageName"=>"images/5_Cover.png","BarCodeImage"=>"barcode/5_Barcode.png","Languages"=>"German,Italian","BarCode"=>"9783831029716","DbPath"=>"xmlfiles/Italian_German.xml"),
							array("orderId"=>"6","Dictionary"=>"Spanish German","ImageName"=>"images/6_Cover.png","BarCodeImage"=>"barcode/6_Barcode.png","Languages"=>"German,Spanish","BarCode"=>"9783831029822","DbPath"=>"xmlfiles/Spanish_German.xml"),
							array("orderId"=>"4","Dictionary"=>"French German","ImageName"=>"images/4_Cover.png","BarCodeImage"=>"barcode/4_Barcode.png","Languages"=>"German,French","BarCode"=>"9783831029686","DbPath"=>"xmlfiles/French_German.xml"),
							array("orderId"=>"3","Dictionary"=>"Arabic German","ImageName"=>"images/3_Cover.png","BarCodeImage"=>"barcode/3_Barcode.png","Languages"=>"German,Arabic","BarCode"=>"9783831029624","DbPath"=>"xmlfiles/Arabic_German.xml")));
//("English_German","German","Arabic_German","Italian_German","Spanish_German","French_German");
?>
