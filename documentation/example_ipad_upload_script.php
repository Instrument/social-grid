<?php

	/*
	
	Note: this example contains NO validation or security measures.  
	If you are going to use this file on a publicly accssible server you should 
	add validation to ensure the source of the uploads, filenames, etc.
  	
  	You can the "source" value submitted from the ipad app to group/organize files 
  	(if there are multiple ipads or something).  The source value is just a string that
	you can set from the PhotoBooth page in the iOS "Settings" app.
	
	Example:
	$source = $_POST['source'];

	*/

	// Make sure a file named "image" was uploaded.
  	if (isset($_FILES['image']['name']))
  	{
  		// Name the file based on the current time, and put it in the 
		// same folder with the PHP script.
  		
  		$destinationPath = date("H-i-s") . ".jpg";
	    move_uploaded_file($_FILES['image']['tmp_name'], $destinationPath);
	}

?>