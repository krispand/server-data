<?php
//$apiVersion =array("dbversion"=>"1.0");
// $dictionaryArray = array("dbversion"=>"1.0","overwritedb"=>"0","databasearray"=>array(array("orderId"=>"1","Dictionary"=>"English German","ImageName"=>"images/1_Cover.png","BarCodeImage"=>"barcode/1_Barcode.png","Languages"=>"German,English","BarCode"=>"9783831029679","DbPath"=>"datafiles/1_BVDTemplate.sqlite"),
							// array("orderId"=>"2","Dictionary"=>"German","ImageName"=>"images/2_Cover.png","BarCodeImage"=>"barcode/2_Barcode.png","Languages"=>"German","BarCode"=>"9783831029662","DbPath"=>"datafiles/2_BVDTemplate.sqlite"),
							// array("orderId"=>"3","Dictionary"=>"Arabic German","ImageName"=>"images/3_Cover.png","BarCodeImage"=>"barcode/3_Barcode.png","Languages"=>"German,Arabic","BarCode"=>"9783831029624","DbPath"=>"datafiles/3_BVDTemplate.sqlite"),
							// array("orderId"=>"4","Dictionary"=>"French German","ImageName"=>"images/4_Cover.png","BarCodeImage"=>"barcode/4_Barcode.png","Languages"=>"German,French","BarCode"=>"9783831029686","DbPath"=>"datafiles/4_BVDTemplate.sqlite"),
							// array("orderId"=>"5","Dictionary"=>"Italian German","ImageName"=>"images/5_Cover.png","BarCodeImage"=>"barcode/5_Barcode.png","Languages"=>"German,Italian","BarCode"=>"9783831029716","DbPath"=>"datafiles/5_BVDTemplate.sqlite"),
							// array("orderId"=>"6","Dictionary"=>"Spanish German","ImageName"=>"images/6_Cover.png","BarCodeImage"=>"barcode/6_Barcode.png","Languages"=>"German,Spanish","BarCode"=>"9783831029822","DbPath"=>"datafiles/6_BVDTemplate.sqlite")));
$cityArray = array("dbversion"=>"1.0","overwritedb"=>"0","databasearray"=>array(array("citytitle"=>"London","bookbarcode"=>"9780241209547","bookjacketpath"=>"jackets/1_jacket.png","bookbarcodeimgpath"=>"barcode/1_barcode.png","walksArray"=>array(array("orderId"=>"1","walktitle"=>"South Bank","walkdistance"=>"0.1 miles(0.1 km)","packageurl"=>"0"),
																																																											array("orderId"=>"2","walktitle"=>"Covent Garden","walkdistance"=>"0.1 miles(0.1 km)","packageurl"=>"1"),
																																																											array("orderId"=>"3","walktitle"=>"Royal London","walkdistance"=>"0.1 miles(0.1 km)","packageurl"=>"2"),
																																																											array("orderId"=>"4","walktitle"=>"The City","walkdistance"=>"0.1 miles(0.1 km)","packageurl"=>"3"),
																																																											array("orderId"=>"5","walktitle"=>"South Kensington","walkdistance"=>"0.1 miles(0.1 km)","packageurl"=>"4"))),
																			array("citytitle"=>"New York","bookbarcode"=>"9781465445537","bookjacketpath"=>"jackets/1_jacket.png","bookbarcodeimgpath"=>"barcode/1_barcode.png","walksArray"=>array(array("orderId"=>"1","walktitle"=>"South Bank","walkdistance"=>"0.1 miles(0.1 km)","packageurl"=>"1.zip"),
																																																											array("orderId"=>"2","walktitle"=>"Covent Garden","walkdistance"=>"0.1 miles(0.1 km)","packageurl"=>"2.zip"),
																																																											array("orderId"=>"3","walktitle"=>"Royal London","walkdistance"=>"0.1 miles(0.1 km)","packageurl"=>"3.zip"),
																																																											array("orderId"=>"4","walktitle"=>"The City","walkdistance"=>"0.1 miles(0.1 km)","packageurl"=>"4.zip"),
																																																											array("orderId"=>"5","walktitle"=>"South Kensington","walkdistance"=>"0.1 miles(0.1 km)","packageurl"=>"5.zip")))));
							
$cityArraytest =  array("dbversion"=>"1.0","overwritedb"=>"0","databasearray"=>array(array("citytitle"=>"London","bookbarcode"=>"0","bookjacketpath"=>"jackets/1_jacket.png","bookbarcodeimgpath"=>"barcode/1_barcode.png","walksArray"=>array(array("orderId"=>"1","walktitle"=>"South Bank","walkdistance"=>"0.1 miles(0.1 km)","packageurl"=>"1.zip"),
																																																											array("orderId"=>"2","walktitle"=>"Covent Garden","walkdistance"=>"0.1 miles(0.1 km)","packageurl"=>"2.zip"),
																																																											array("orderId"=>"3","walktitle"=>"Royal London","walkdistance"=>"0.1 miles(0.1 km)","packageurl"=>"3.zip"),
																																																											array("orderId"=>"4","walktitle"=>"The City","walkdistance"=>"0.1 miles(0.1 km)","packageurl"=>"4.zip"),
																																																											array("orderId"=>"5","walktitle"=>"South Kensington","walkdistance"=>"0.1 miles(0.1 km)","packageurl"=>"5.zip"))),
																			array("citytitle"=>"London","bookbarcode"=>"0","bookjacketpath"=>"jackets/1_jacket.png","bookbarcodeimgpath"=>"barcode/1_barcode.png","walksArray"=>array(array("orderId"=>"1","walktitle"=>"South Bank","walkdistance"=>"0.1 miles(0.1 km)","packageurl"=>"1.zip"),
																																																											array("orderId"=>"2","walktitle"=>"Covent Garden","walkdistance"=>"0.1 miles(0.1 km)","packageurl"=>"2.zip"),
																																																											array("orderId"=>"3","walktitle"=>"Royal London","walkdistance"=>"0.1 miles(0.1 km)","packageurl"=>"3.zip"),
																																																											array("orderId"=>"4","walktitle"=>"The City","walkdistance"=>"0.1 miles(0.1 km)","packageurl"=>"4.zip"),
																																																											array("orderId"=>"5","walktitle"=>"South Kensington","walkdistance"=>"0.1 miles(0.1 km)","packageurl"=>"5.zip")))));
									
							
$cityArrayAndroid =  array("dbversion"=>"1.0","overwritedb"=>"0","databasearray"=>array(array("citytitle"=>"London","bookbarcode"=>"0","bookjacketpath"=>"jackets/1_jacket.png","bookbarcodeimgpath"=>"barcode/1_barcode.png","walksArray"=>array(array("orderId"=>"1","walktitle"=>"South Bank","walkdistance"=>"0.1 miles(0.1 km)","packageurl"=>"1.zip"),
																																																											array("orderId"=>"2","walktitle"=>"Covent Garden","walkdistance"=>"0.1 miles(0.1 km)","packageurl"=>"2.zip"),
																																																											array("orderId"=>"3","walktitle"=>"Royal London","walkdistance"=>"0.1 miles(0.1 km)","packageurl"=>"3.zip"),
																																																											array("orderId"=>"4","walktitle"=>"The City","walkdistance"=>"0.1 miles(0.1 km)","packageurl"=>"4.zip"),
																																																											array("orderId"=>"5","walktitle"=>"South Kensington","walkdistance"=>"0.1 miles(0.1 km)","packageurl"=>"5.zip"))),
																			array("citytitle"=>"London","bookbarcode"=>"0","bookjacketpath"=>"jackets/1_jacket.png","bookbarcodeimgpath"=>"barcode/1_barcode.png","walksArray"=>array(array("orderId"=>"1","walktitle"=>"South Bank","walkdistance"=>"0.1 miles(0.1 km)","packageurl"=>"1.zip"),
																																																											array("orderId"=>"2","walktitle"=>"Covent Garden","walkdistance"=>"0.1 miles(0.1 km)","packageurl"=>"2.zip"),
																																																											array("orderId"=>"3","walktitle"=>"Royal London","walkdistance"=>"0.1 miles(0.1 km)","packageurl"=>"3.zip"),
																																																											array("orderId"=>"4","walktitle"=>"The City","walkdistance"=>"0.1 miles(0.1 km)","packageurl"=>"4.zip"),
																																																											array("orderId"=>"5","walktitle"=>"South Kensington","walkdistance"=>"0.1 miles(0.1 km)","packageurl"=>"5.zip")))));
									
$cityArraytestAndroid = array("dbversion"=>"1.0","overwritedb"=>"0","databasearray"=>array(array("citytitle"=>"London","bookbarcode"=>"0","bookjacketpath"=>"jackets/1_jacket.png","bookbarcodeimgpath"=>"barcode/1_barcode.png","walksArray"=>array(array("orderId"=>"1","walktitle"=>"South Bank","walkdistance"=>"0.1 miles(0.1 km)","packageurl"=>"1.zip"),
																																																											array("orderId"=>"2","walktitle"=>"Covent Garden","walkdistance"=>"0.1 miles(0.1 km)","packageurl"=>"2.zip"),
																																																											array("orderId"=>"3","walktitle"=>"Royal London","walkdistance"=>"0.1 miles(0.1 km)","packageurl"=>"3.zip"),
																																																											array("orderId"=>"4","walktitle"=>"The City","walkdistance"=>"0.1 miles(0.1 km)","packageurl"=>"4.zip"),
																																																											array("orderId"=>"5","walktitle"=>"South Kensington","walkdistance"=>"0.1 miles(0.1 km)","packageurl"=>"5.zip"))),
																			array("citytitle"=>"London","bookbarcode"=>"0","bookjacketpath"=>"jackets/1_jacket.png","bookbarcodeimgpath"=>"barcode/1_barcode.png","walksArray"=>array(array("orderId"=>"1","walktitle"=>"South Bank","walkdistance"=>"0.1 miles(0.1 km)","packageurl"=>"1.zip"),
																																																											array("orderId"=>"2","walktitle"=>"Covent Garden","walkdistance"=>"0.1 miles(0.1 km)","packageurl"=>"2.zip"),
																																																											array("orderId"=>"3","walktitle"=>"Royal London","walkdistance"=>"0.1 miles(0.1 km)","packageurl"=>"3.zip"),
																																																											array("orderId"=>"4","walktitle"=>"The City","walkdistance"=>"0.1 miles(0.1 km)","packageurl"=>"4.zip"),
																																																											array("orderId"=>"5","walktitle"=>"South Kensington","walkdistance"=>"0.1 miles(0.1 km)","packageurl"=>"5.zip")))));
		
?>
