<?php
// Include your database connection code here (e.g., db_conn.php)
require_once('dbconnect.php');

// Check if the request is a POST request
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Check if 'userid' is set
    if (isset($_POST['userid']) && isset($_POST['days'])) {
        // Get the Userid and days from the POST data
        $userid = trim($_POST['userid']);
        $days = trim($_POST['days']);

        // SQL query to update the days in the database
        $sql = "UPDATE cycleupdate SET days = '$days' WHERE LOWER(TRIM(Userid)) = LOWER(TRIM('$userid'))";

        // Execute the query
        if ($conn->query($sql) === TRUE) {
            // Return success status and updated days as JSON
            header('Content-Type: application/json');
            echo json_encode(array('status' => true, 'days' => $days));
        } else {
            // Return error message if query execution failed
            header('Content-Type: application/json');
            echo json_encode(array('status' => false, 'message' => 'Error updating days in the database: ' . $conn->error));
        }
    } else {
        // 'userid' or 'days' not provided
        header('Content-Type: application/json');
        echo json_encode(array('status' => false, 'message' => 'Please provide both userid and days.'));
    }
} else {
    // Handle non-POST requests (e.g., return an error response)
    header('Content-Type: application/json');
    echo json_encode(array('status' => false, 'message' => 'Invalid request method.'));
}

// Close the database connection
$conn->close();
?>
