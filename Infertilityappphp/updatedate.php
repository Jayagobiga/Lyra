<?php
// Include your database connection script
require_once('dbconnect.php');

// Check if the request is a POST request
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Check if the required parameters are set
    if (isset($_POST['userid']) && isset($_POST['updatedate']) && isset($_POST['dayDifference'])) {
        // Get input data from the application
        $userid = $_POST['userid'];
        $updatedate = $_POST['updatedate'];
        $dayDifference = $_POST['dayDifference'];

        // Assuming 'updatedate' is in a format that can be parsed by DateTime
        try {
            $date = new DateTime($updatedate);
            $formattedDate = $date->format('Y/m/d');
        } catch (Exception $e) {
            // Handle exception if date parsing fails
            $response = array('status' => false, 'message' => 'Date parsing error: ' . $e->getMessage());
            echo json_encode($response);
            exit; // Stop script execution
        }

        // Check if the user exists in the database
        $check_sql = "SELECT * FROM cycleupdate WHERE Userid = ?";
        $stmt = $conn->prepare($check_sql);
        $stmt->bind_param("s", $userid);
        $stmt->execute();
        $result = $stmt->get_result();

        if ($result->num_rows > 0) {
            // User exists, update the row
            $update_sql = "UPDATE cycleupdate SET date = ?, days = ? WHERE Userid = ?";
            $stmt = $conn->prepare($update_sql);
            $stmt->bind_param("sss", $formattedDate, $dayDifference, $userid);
            $execute = $stmt->execute();

            if ($execute) {
                // Successful update
                $response = array('status' => true, 'message' => 'Date and day difference updated successfully.');
            } else {
                // Error in database update
                $response = array('status' => false, 'message' => 'Error: ' . $stmt->error);
            }
        } else {
            // User does not exist, create a new row
            $insert_sql = "INSERT INTO cycleupdate (Userid, date, days) VALUES (?, ?, ?)";
            $stmt = $conn->prepare($insert_sql);
            $stmt->bind_param("sss", $userid, $formattedDate, $dayDifference);
            $execute = $stmt->execute();

            if ($execute) {
                // Successful insertion
                $response = array('status' => true, 'message' => 'New user created with date and day difference.');
            } else {
                // Error in database insertion
                $response = array('status' => false, 'message' => 'Error: ' . $stmt->error);
            }
        }

        echo json_encode($response);
    } else {
        // Required parameters are missing
        $response = array('status' => false, 'message' => 'Required parameters are missing.');
        echo json_encode($response);
    }
} else {
    // Handle non-POST requests
    $response = array('status' => false, 'message' => 'Invalid request method.');
    echo json_encode($response);
}

// Close the database connection
$conn->close();
?>
