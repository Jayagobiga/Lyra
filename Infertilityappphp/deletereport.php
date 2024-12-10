<?php
// Include your database connection code
require_once('dbconnect.php');

// Check if the request is a POST request
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Get input data from the application
    if (isset($_POST['userId']) && isset($_POST['date'])) {
        $userid = $_POST['userId'];
        $date = $_POST['date'];

        // Start a transaction to ensure data consistency
        $conn->begin_transaction();

        try {
            // Prepare the delete statement for 'addreport' table
            $delete_report_stmt = $conn->prepare("DELETE FROM addreport WHERE Userid = ? AND date = ?");
            if ($delete_report_stmt === false) {
                throw new Exception("Failed to prepare delete statement for addreport: " . $conn->error);
            }
            $delete_report_stmt->bind_param("ss", $userid, $date);
            if (!$delete_report_stmt->execute()) {
                throw new Exception("Failed to execute delete statement for addreport: " . $delete_report_stmt->error);
            }

            // Prepare the delete statement for 'uploadimage' table
            $delete_image_stmt = $conn->prepare("DELETE FROM uploadimage WHERE Userid = ? AND date = ?");
            if ($delete_image_stmt === false) {
                throw new Exception("Failed to prepare delete statement for uploadimage: " . $conn->error);
            }
            $delete_image_stmt->bind_param("ss", $userid, $date);
            if (!$delete_image_stmt->execute()) {
                throw new Exception("Failed to execute delete statement for uploadimage: " . $delete_image_stmt->error);
            }

            // If both deletions were successful, commit the transaction
            $conn->commit();

            // Send success response
            $response = array('status' => 'success', 'message' => 'Report and associated images deleted successfully.');
        } catch (Exception $e) {
            // Rollback the transaction in case of an error
            $conn->rollback();

            // Send error response
            $response = array('status' => 'error', 'message' => $e->getMessage());
        }

        // Close the prepared statements
        if ($delete_report_stmt) {
            $delete_report_stmt->close();
        }
        if ($delete_image_stmt) {
            $delete_image_stmt->close();
        }
    } else {
        // Handle missing userId or date in POST request
        $response = array('status' => 'error', 'message' => 'Missing userId or date parameter.');
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
