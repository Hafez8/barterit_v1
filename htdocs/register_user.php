<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}
include_once("dbconnect.php");
$email = $_POST['email'];
$name = $_POST['name'];
$password = sha1($_POST['password']);
$phone = $_POST['phone'];



$sqlinsert = "INSERT INTO tbl_users (user_email,user_name,user_password,
user_phone) VALUES('$email','$name','$password','$phone')";


if ($conn‐>query($sqlinsert) === TRUE) {
$response = array('status' => 'success', 'data' => null);
sendEmail($email);
       sendJsonResponse($response);
}else{
$response = array('status' => 'failed', 'data' => null);
sendJsonResponse($response);
}
function sendJsonResponse($sentArray)
{
    header(Content‐Type: 'application/json');
    echo json_encode($sentArray);
}
?>