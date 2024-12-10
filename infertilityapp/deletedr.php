<?php
// Include your database connection code
require_once('dbconnect.php');

// Check if the request is a POST request
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Get input data from the application
    if (isset($_POST['userId'])) {
        $userid = $_POST['userId'];

        // Prepare a SQL statement to fetch the doctor details
        $select_stmt = $conn->prepare("SELECT * FROM doctor_profile WHERE dr_userid = ?");
        if ($select_stmt === false) {
            $response = array('status' => 'error', 'message' => 'Failed to prepare select statement.');
            echo json_encode($response);
            exit;
        }

        // Bind the user ID parameter to the prepared statement
        $select_stmt->bind_param("s", $userid);

        // Execute the query
        $select_stmt->execute();
        $select_result = $select_stmt->get_result();

        if ($select_result->num_rows > 0) {
            // User found, fetch the doctor details
            $doctor_data = array();
            while ($row = $select_result->fetch_assoc()) {
                $doctor_data[] = $row;
            }

            // Now, delete the doctor profile
            $delete_stmt = $conn->prepare("DELETE FROM doctor_profile WHERE dr_userid = ?");
            if ($delete_stmt === false) {
                $response = array('status' => 'error', 'message' => 'Failed to prepare delete statement.');
                echo json_encode($response);
                exit;
            }

            // Bind the user ID for deletion
            $delete_stmt->bind_param("s", $userid);

            // Execute the delete query
            if ($delete_stmt->execute()) {
                // Doctor profile deleted successfully
                $response = array('status' => 'success', 'message' => 'Doctor profile deleted successfully.', 'data' => $doctor_data);
            } else {
                // Error while deleting
                $response = array('status' => 'error', 'message' => 'Failed to delete doctor profile.');
            }

            // Close the delete statement
            $delete_stmt->close();
        } else {
            // User not found
            $response = array('status' => 'error', 'message' => 'Doctor not found.');
        }

        // Close the select statement
        $select_stmt->close();
    } else {
        // Handle missing userId in POST request
        $response = array('status' => 'error', 'message' => 'Missing userId parameter.');
    }

    // Send the response as JSON
    echo json_encode($response);
} else {
    // Handle non-POST requests
    $response = array('status' => 'error', 'message' => 'Invalid request method.');
    echo json_encode($response);
}

// Close the database connection
$conn->close();
?>
