<?

	ini_set("memory_limit","500M");
	ini_set("upload_max_filesize","500M");
	ini_set("post_max_size","500M");


function uploadfile($theType,$target,$new_name,$new_path,$max_width,$max_height){
	
	
	
	
	// check for image upload 
	if (empty($_FILES[$target]) OR $_FILES[$target]['error'] != UPLOAD_ERR_OK) {
		die('error files empty!');
	} 
	$orig_source = ($_FILES[$target]['tmp_name']);
	$orig_type = ($_FILES[$target]['type']);
	
	
	
	if ($theType == "file"){
				move_uploaded_file($_FILES[$target]["tmp_name"],$new_path.$new_name);
	}
	
	
	if ($theType == "image"){
	
					// check image type
					if ($orig_type == 'image/pjpeg' || $orig_type == 'image/jpeg') { 
							$strFileExt = '.jpg';
						}else if ($orig_type == 'image/x-png' || $orig_type == 'image/png'){
							$strFileExt = '.png';
						} else{
							die('jpeg,png only');
						}
					$new_name = $new_name.$strFileExt;
					
					$filepath = $new_path.$new_name;
					
						// check size?
			//$filesize=filesize($orig_source);
			
			//if ($filesize > 2000000) { die('too big');}
					
					// Get original width and height
					$size = getimagesize($orig_source);
					$orig_width = $size[0];
					$orig_height = $size[1];
					$imageerror = array();
				/*	$imageerror['flag'] = false;
					 
					if($orig_width !=  $max_width || $orig_height != $max_height){
						$imageerror['flag'] = true;
						$imageerror['target'] = $target;
						return $imageerror; 
					} */
					
					
					
					
					
					
					// if original width / original height is greater 
					// than new width / new height 
					/*if ($max_width=='' && $max_height ==''){
						$resize_width = $orig_width;
						$resize_height = $orig_height;
					} else {
						if ($orig_width/$orig_height > $max_width/$max_height) { 
							// resize to the new width 
							$resize_width = $max_width; 
							// ... and get the middle part of the new image 
							// what is the resized height? 
							$resize_height = ceil(($max_width/$orig_width) * $orig_height); 
						
						} else {
							// then resize to the new height... 
							$resize_height = $max_height; 
							// ... and get the middle part of the new image 
							// what is the resized width? 
							$resize_width = ceil(($max_height/$orig_height) * $orig_width); 
						}// Resample
					} */
				
						$resize_width = $max_width;
						$resize_height = $max_height;
					// FORCE INTO DIMESIONS
					
					if ($strFileExt == '.jpg'){
						$resized_image = imagecreatetruecolor($resize_width, $resize_height);
						$image = imagecreatefromjpeg($orig_source);
						imagecopyresampled($resized_image, $image, 0, 0, 0, 0, $resize_width, $resize_height, $orig_width, $orig_height);
						imagejpeg($resized_image, $filepath ,90);
					}
					
					if ($strFileExt == '.png'){
						$image = imagecreatefrompng($orig_source);
						$resized_image = imagecreatetruecolor($resize_width, $resize_height);
						$trnprt_indx = imagecolortransparent($image);
						
								if ($trnprt_indx >= 0) {
										// Get the original image's transparent color's RGB values
										$trnprt_color    = imagecolorsforindex($image, $trnprt_indx);
										// Allocate the same color in the new image resource
										$trnprt_indx    = imagecolorallocate($resized_image, $trnprt_color['red'], $trnprt_color['green'], $trnprt_color['blue']);
										// Completely fill the background of the new image with allocated color.
										imagefill($resized_image, 0, 0, $trnprt_indx);
										// Set the background color for new image to transparent
										imagecolortransparent($resized_image, $trnprt_indx);
			  
									 } else {
									 	
										 // Turn off transparency blending (temporarily)
										imagealphablending($resized_image, false);
										// Create a new transparent color for image
										$color = imagecolorallocatealpha($resized_image, 0, 0, 0, 127);
										// Completely fill the background of the new image with allocated color.
										imagefill($resized_image, 0, 0, $color);
										// Restore transparency blending
										imagesavealpha($resized_image, true);
								}
								
								imagecopyresampled($resized_image, $image, 0, 0, 0, 0, $resize_width, $resize_height, $orig_width, $orig_height);
								imagepng($resized_image, $filepath);
						}
	}
}

function deltmpfiles($target){// delete temp images
	$orig_source = ($_FILES[$target]['tmp_name']);
	unlink($orig_source);
}

function displayImageUploader($fieldname, $dbfilename, $newfilename, $filepath){
	if($dbfilename!=''){
		$hide = 'style="display:none"';
		echo ('<div id="preview_'.$fieldname.'" ><div class="previewborder">
			<img src="'.$filepath.$dbfilename.'?'.rand(1,111111).'" border="0" />
			<a href="#" onClick="'.$fieldname.'dbname.value=\'\'; if (confirm(\'Are you sure you want to delete this image?\')){getElementById(\'preview_'.$fieldname.'\').style.display=\'none\';getElementById(\'browse_'.$fieldname.'\').style.display=\'inline\'}"><img src="../assets/graphics/icon_cross.gif" border="0" alt="Delete" /></a>
		</div></div>');
	}
	echo ('<div id="browse_'.$fieldname.'" '.$hide.' > 
			<input type="file" name="'.$fieldname.'" class="width200" >
			<input type="hidden" name="'.$fieldname.'dbname" value="'.$dbfilename.'" >
			<input type="hidden" name="'.$fieldname.'newname" value="'.$newfilename.'" >
		</div>');
}
?>
