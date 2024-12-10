<?php
// Include your database connection code here (e.g., db_conn.php)
require_once('dbconnect.php');

// Check if the request is a POST request
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Get input data from the application
    $userid = $_POST['userid'];
    $password = $_POST['password'];
    $repassword = $_POST['repassword'];

    // Check if password and repassword match
    if ($password !== $repassword) {
        // Password and repassword don't match, return an error response
        $response = array('status' => 'error', 'message' => 'Password and repassword should be the same.');
        echo json_encode($response);
        exit;
    }

    // Check if the user_id already exists in addpatient
    $check_sql = "SELECT Userid FROM addpatient WHERE Userid = '$userid'";
    $check_result = $conn->query($check_sql);

    if ($check_result->num_rows > 0) {
        // User exists, perform the update
        // Note: You need to include the necessary fields like Medicinename, Time, etc. in your form and fetch them here.
        $update_sql = "UPDATE addpatient SET Password = '$password', Repassword = '$repassword' WHERE Userid = '$userid'";

        if ($conn->query($update_sql) === TRUE) {
            // Successful update
            $response = array('status' => true, 'message' => 'Patient details updated successfully.');
            echo json_encode($response);
        } else {
            // Error in database update
            $response = array('status' => false, 'message' => 'Error: ' . $conn->error);
            echo json_encode($response);
        }
    } else {
        // User doesn't exist, return an error response
        $response = array('status' => false, 'message' => 'User does not exist. You can only update existing users.');
        echo json_encode($response);
    }
} else {
    // Handle non-POST requests (e.g., return an error response)
    $response = array('status' => false, 'message' => 'Invalid request method.');
    echo json_encode($response);
}

// Close the database connection
$conn->close();
?>
