<?php
// Include your database connection code here (e.g., db_conn.php)
require_once('dbconnect.php');

// Check if the request is a POST request
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Check if 'userid' is set and not empty
    if (isset($_POST['userid']) && !empty(trim($_POST['userid']))) {
        // Get the Userid from the POST data and sanitize it
        $userid = $conn->real_escape_string(trim($_POST['userid']));

        // SQL query to retrieve patient information based on Userid
        $sql = "SELECT * FROM addspouse WHERE LOWER(TRIM(Userid)) = LOWER('$userid')";
        $result = $conn->query($sql);

        if ($result) {
            if ($result->num_rows > 0) {
                // Fetch patient details as an associative array
                $spouseDetails = $result->fetch_assoc();

                // Return patient details as JSON with proper Content-Type header
                header('Content-Type: application/json');
                echo json_encode(array('status' => true, 'spouseDetails' => $spouseDetails));
            } else {
                // No patient found with the provided Userid
                header('Content-Type: application/json');
                echo json_encode(array('status' => false, 'message' => 'No spouse found with the provided Userid.'));
            }
        } else {
            // Query execution failed
            header('Content-Type: application/json');
            echo json_encode(array('status' => false, 'message' => 'Error executing the query.'));
        }
    } else {
        // 'userid' not provided or empty
        header('Content-Type: application/json');
        echo json_encode(array('status' => false, 'message' => 'Please provide a valid userid.'));
    }
} else {
    // Handle non-POST requests (e.g., return an error response)
    header('Content-Type: application/json');
    echo json_encode(array('status' => false, 'message' => 'Invalid request method.'));
}

// Close the database connection
$conn->close();
?>
