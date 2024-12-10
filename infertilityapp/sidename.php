<?php
// Include your database connection code here (e.g., db_conn.php)
require_once('dbconnect.php');

// Check if the request is a POST request
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Check if 'userid' is set
    if (isset($_POST['userid'])) {
        // Get the Userid from the POST data
        $userid = trim($_POST['userid']);

        // SQL query to retrieve patient information based on Userid
        $sql = "SELECT Userid,Name FROM addpatient WHERE LOWER(TRIM(Userid)) = LOWER(TRIM('$userid'))";
        $result = $conn->query($sql);

        if ($result->num_rows > 0) {
            // Fetch patient details as an associative array
            $patientDetails = $result->fetch_assoc();

            // Return patient details as JSON with proper Content-Type header
            header('Content-Type: application/json');
            echo json_encode(array('status' => true, 'name' => $patientDetails));
        } else {
            // No patient found with the provided Userid
            header('Content-Type: application/json');
            echo json_encode(array('status' => false, 'message' => 'No patient found with the provided Userid.'));
        }
    } else {
        // 'userid' not provided
        header('Content-Type: application/json');
        echo json_encode(array('status' => false, 'message' => 'Please provide a userid.'));
    }
} else {
    // Handle non-POST requests (e.g., return an error response)
    header('Content-Type: application/json');
    echo json_encode(array('status' => false, 'message' => 'Invalid request method.'));
}

// Close the database connection
$conn->close();
?>
