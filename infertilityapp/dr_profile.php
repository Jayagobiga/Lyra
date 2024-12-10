<?php
// Include your database connection code here (e.g., db_conn.php)
require_once('dbconnect.php');

// Check if the request is a POST request
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Get input data from the application
    $userid = $_POST['userId'];

    // Select data from the doctor_profile table based on the provided userid
    $select_sql = "SELECT * FROM doctor_profile WHERE dr_userid = '$userid'";
    $select_result = $conn->query($select_sql);

    if ($select_result->num_rows > 0) {
        // User found, fetch all rows
        $user_data = array();
        while ($row = $select_result->fetch_assoc()) {
            $user_data[] = $row;
        }

        $response = array('status' => 'success', 'message' => 'User details retrieved successfully.', 'data' => $user_data);
        echo json_encode($response);
    } else {
        // User not found
        $response = array('status' => 'error', 'message' => 'User not found.');
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
