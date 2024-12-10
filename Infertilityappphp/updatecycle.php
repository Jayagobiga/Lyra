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
        $sql = "SELECT days FROM cycleupdate WHERE LOWER(TRIM(Userid)) = LOWER(TRIM(?))";
        $stmt = $conn->prepare($sql);
        $stmt->bind_param("s", $userid);
        $stmt->execute();
        $result = $stmt->get_result();

        if ($result->num_rows > 0) {
            // Fetch patient details as an associative array
            $remainingdays = $result->fetch_assoc();

            // Return patient details as JSON with proper Content-Type header
            header('Content-Type: application/json');
            echo json_encode(array('status' => true, 'days' => $remainingdays));
        } else {
            // No patient found with the provided Userid, insert new record
            $insert_sql = "INSERT INTO cycleupdate (Userid, date, days) VALUES (?, NULL, 0)";
            $stmt = $conn->prepare($insert_sql);
            $stmt->bind_param("s", $userid);
            if ($stmt->execute()) {
                // Return response indicating a new record was created
                header('Content-Type: application/json');
                echo json_encode(array('status' => true, 'message' => 'New user created with default values.', 'days' => 0));
            } else {
                // Error inserting new record
                header('Content-Type: application/json');
                echo json_encode(array('status' => false, 'message' => 'Error creating new user: ' . $stmt->error));
            }
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
