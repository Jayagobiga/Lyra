<?php
// Include your database connection script
require_once('dbconnect.php');

// Check if the request is a POST request
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Check if the required parameter is set
    if (isset($_POST['userid'])) {
        // Get input data from the application
        $userid = $_POST['userid'];

        // Get the cycleupdate date from the database
        $select_sql = "SELECT date FROM cycleupdate WHERE Userid = ?";
        $stmt = $conn->prepare($select_sql);
        $stmt->bind_param("s", $userid);
        $stmt->execute();
        $result = $stmt->get_result();

        if ($result->num_rows > 0) {
            $row = $result->fetch_assoc();
            $cycleupdateDate = $row['date'];

            // Log the cycleupdateDate for debugging
            error_log("Cycleupdate Date: " . $cycleupdateDate);

            // Try different date formats for cycleupdate date
            $formats = ['Y-m-d', 'Y/m/d', 'd-m-Y', 'd/m/Y'];
            $cycleupdateDateTime = false;

            foreach ($formats as $format) {
                $cycleupdateDateTime = DateTime::createFromFormat($format, $cycleupdateDate);
                if ($cycleupdateDateTime !== false) {
                    break;
                }
            }

            if ($cycleupdateDateTime === false) {
                $response = array('status' => false, 'message' => 'Error parsing cycleupdate date.');
                echo json_encode($response);
                exit;
            }

            // Get the current date
            $currentDateTime = new DateTime();

            // Calculate the difference in days
            $interval = $currentDateTime->diff($cycleupdateDateTime);
            $dayDifference = $interval->days + 1;

            // Update the 'days' column in 'cycleupdate' table
            $update_sql = "UPDATE cycleupdate SET days = ? WHERE Userid = ?";
            $stmt = $conn->prepare($update_sql);
            $stmt->bind_param("ss", $dayDifference, $userid);
            $execute = $stmt->execute();

            if ($execute) {
                // Successful update
                $response = array('status' => true, 'message' => 'Day difference updated successfully.', 'dayDifference' => $dayDifference);
            } else {
                // Error in database update
                $response = array('status' => false, 'message' => 'Error: ' . $stmt->error);
            }

            echo json_encode($response);
        } else {
            // User not found in cycleupdate table
            $response = array('status' => false, 'message' => 'User not found in cycleupdate table.');
            echo json_encode($response);
        }
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
