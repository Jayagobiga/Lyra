<?php
require("dbconnect.php");

$response = array();

// Check if the request is a GET request
if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    // Check if the 'userid' query parameter is provided
    if (isset($_GET["userid"])) {
        $userid = $_GET["userid"];

        // SQL query to retrieve images associated with the specific user
        $sql = "SELECT Userid FROM uploadimage WHERE Userid = '$userid'";

        $result = mysqli_query($conn, $sql);

        if ($result) {
            $imagePaths = array();
            while ($row = mysqli_fetch_assoc($result)) {
                $imagePaths[] = $row['image_path'];
            }

            $response['status'] = 'success';
            $response['images'] = $imagePaths;
        } else {
            $response['status'] = 'error';
            $response['message'] = 'Error: ' . mysqli_error($conn);
        }
    } else {
        // 'userid' query parameter not provided
        $response['status'] = 'error';
        $response['message'] = 'Please provide a userid.';
    }
} else {
    // Handle non-GET requests (e.g., return an error response)
    $response['status'] = 'error';
    $response['message'] = 'Invalid request method.';
}

header('Content-Type: application/json');
echo json_encode($response);
?>
