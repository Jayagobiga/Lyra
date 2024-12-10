<?php
require("dbconnect.php");

$response = array();

if (isset($_POST["userid"])) {
    $userid = $_POST["userid"];
    $fileName = $_FILES["video"]["name"];
    $tempName = $_FILES["video"]["tmp_name"];
    $folder = "videos/" . $fileName; 

    if (move_uploaded_file($tempName, $folder)) {
        $sql = "INSERT INTO uploadimage VALUES ('','$userid', '$folder')";

        if (mysqli_query($conn, $sql)) {
            $response['status'] = 'success';
            $response['message'] = 'Data inserted successfully.';
        } else {
            $response['status'] = 'error';
            $response['message'] = 'Data not inserted. Error: ' . mysqli_error($conn);
        }
    } else {
        $response['status'] = 'error';
        $response['message'] = 'File upload failed.';
    }
} else {
    $response['status'] = 'error';
    $response['message'] = 'Invalid request.';
}

header('Content-Type: application/json');
echo json_encode($response);
?>
