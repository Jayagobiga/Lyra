<?php
error_reporting(0);
require_once('dbconnect.php');

// Get user input
$username = $_GET['userId'];
$password = $_GET['pass'];

// Database query
$loginqry = "SELECT * FROM signup WHERE Userid = '$username' AND Password = '$password'";
$qry = mysqli_query($conn, $loginqry);

// Prepare the response
$response = [];

if (mysqli_num_rows($qry) > 0) {
    $userArray = [];
    while ($userObj = mysqli_fetch_assoc($qry)) {
        $userArray[] = $userObj;
    }
    $response['status'] = true;
    $response['message'] = "Login Successfully";
    $response['data'] = $userArray;
} else {
    $response['status'] = false;
    $response['message'] = "Login Failed";
}

// Set the HTTP response headers
header('Content-Type: application/json; charset=UTF-8');

// Send the JSON response
echo json_encode($response);
?>