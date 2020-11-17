<?php

require_once __DIR__."/../db_support_functions.php";

foreach($_FILES as $receivedFile) {
	$md5 = md5_file($receivedFile['tmp_name']);
	move_uploaded_file( $receivedFile['tmp_name'], "/ExtraSpace/Dropbox/IntranetV2_Files/".$md5);

	$json = [];
	$json['createdFromEmailAttachment'] = true;
	$json['receivedAtEmailInbox'] = $_POST['RecipientMailbox'] ?? "";

	$json = json_encode($json);
	// SYS_FilesNew : creates a new file (link) in the database
	//             ( Id, MimeType, DateCreated, Extra )
	sql("CALL SYS_FilesNew('$md5', 'application/pdf', NULL, '$json')");

}

