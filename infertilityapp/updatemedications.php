<?php
// Include your database connection code here (e.g., db_conn.php)
require_once('dbconnect.php');

// Check if the request is a POST request
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Get input data from the application
    $userid = $_POST['userid'];
    $medicinename = $_POST['medicinename'];
    $time = $_POST['time'];

    // Check if the user_id already exists in medicationdetails
    $check_sql = "SELECT Userid FROM medicationdetails WHERE Userid = '$userid'";
    $check_result = $conn->query($check_sql);

    if ($check_result->num_rows > 0) {
        // User exists, perform the update
        $update_sql = "UPDATE medicationdetails SET MedicineName = '$medicinename', Time = '$time' WHERE Userid = '$userid'";

        if ($conn->query($update_sql) === TRUE) {
            // Successful update
            $response = array('status' => 'success', 'message' => 'medical details updated successfully.');
            echo json_encode($response);
        } else {
            // Error in database update
            $response = array('status' => 'error', 'message' => 'Error: ' . $conn->error);
            echo json_encode($response);
        }
    } else {
        // User doesn't exist, return an error response
        $response = array('status' => 'error', 'message' => 'User does not exist. You can only update existing users.');
        echo json_encode($response);
    }
} else {
    // Handle non-POST requests (e.g., return an error response)
    $response = array('status' => 'error', 'message' => 'Invalid request method.');
    echo json_encode($response);
}

// Close the database connection
$conn->close();
?>
