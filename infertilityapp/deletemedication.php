<?php
// Include your database connection code here (e.g., db_conn.php)
require_once('dbconnect.php');

// Check if the request is a POST request
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Check if 'userid', 'medication', and 'date' are set in the POST data
    if (isset($_POST['userid']) && isset($_POST['medication']) && isset($_POST['date'])) {
        // Get the input values from the POST request
        $userid = trim($_POST['userid']);
        $medicinename = trim($_POST['medication']);
        $date = trim($_POST['date']);

        // SQL query to delete the specific entry based on userid, medicine name, and date
        $delete_sql = "DELETE FROM medicationdetails WHERE LOWER(TRIM(Userid)) = LOWER(TRIM(?)) AND LOWER(TRIM(Medication)) = LOWER(TRIM(?)) AND date = ?";

        // Prepare the SQL statement
        if ($stmt = $conn->prepare($delete_sql)) {
            // Bind parameters to the query
            $stmt->bind_param("sss", $userid, $medicinename, $date);

            // Execute the query
            if ($stmt->execute()) {
                if ($stmt->affected_rows > 0) {
                    // Return success if a row was actually deleted
                    $response = array('status' => 'success', 'message' => 'Medication details deleted successfully.');
                } else {
                    // No rows matched the criteria
                    $response = array('status' => 'error', 'message' => 'No matching medication record found.');
                }
            } else {
                // Return an error if the query fails
                $response = array('status' => 'error', 'message' => 'Error: ' . $stmt->error);
            }
            // Close the statement
            $stmt->close();
        } else {
            // If preparing the statement fails
            $response = array('status' => 'error', 'message' => 'Error preparing statement.');
        }

        // Output the response as JSON
        header('Content-Type: application/json');
        echo json_encode($response);
    } else {
        // If the required fields are missing, return an error response
        $response = array('status' => 'error', 'message' => 'Please provide userid, medicinename, and date.');
        header('Content-Type: application/json');
        echo json_encode($response);
    }
} else {
    // Handle non-POST requests (e.g., return an error response)
    $response = array('status' => 'error', 'message' => 'Invalid request method.');
    header('Content-Type: application/json');
    echo json_encode($response);
}

// Close the database connection
$conn->close();
?>
