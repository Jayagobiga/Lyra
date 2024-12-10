<?php
// Include your database connection script
require_once('dbconnect.php');

// Function to add an ordinal suffix to numbers
function numberSuffix($number) {
    if (!in_array(($number % 100), array(11, 12, 13))) {
        switch ($number % 10) {
            // Handle 1st, 2nd, 3rd
            case 1:  return $number . 'st';
            case 2:  return $number . 'nd';
            case 3:  return $number . 'rd';
        }
    }
    return $number . 'th';
}

// Check if the request is a POST request
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Check if the required parameters are set
    if (isset($_POST['userid']) && isset($_POST['updatedate'])) {
        // Get input data from the application
        $userid = $_POST['userid'];
        $updatedate = $_POST['updatedate'];

        // Assuming 'updatedate' is in a format that can be parsed by DateTime
        try {
            $date = new DateTime($updatedate);
            $currentDate = new DateTime(); // Get the current date

            // Calculate the difference in days between the current date and the uploaded date
            $interval = $currentDate->diff($date);
            $daysDifference = $interval->days+1;

            // Apply the number suffix
            $daysWithSuffix = numberSuffix($daysDifference);

            // Format the uploaded date for insertion or update
            $formattedDate = $date->format('Y/m/d');
        } catch (Exception $e) {
            // Handle exception if date parsing fails
            $response = array('status' => false, 'message' => 'Date parsing error: ' . $e->getMessage());
            echo json_encode($response);
            exit; // Stop script execution
        }

        // Check if the userid already exists in cycleupdate
        $check_sql = "SELECT Userid FROM cycleupdate WHERE Userid = ?";
        $stmt = $conn->prepare($check_sql);
        $stmt->bind_param("s", $userid);
        $stmt->execute();
        $check_result = $stmt->get_result();

        if ($check_result) {
            // If user exists, perform the update; otherwise, perform the insert
            if ($check_result->num_rows > 0) {
                // User exists, perform the update
                $update_sql = "UPDATE cycleupdate SET date = ?, days = ? WHERE Userid = ?";
                $stmt = $conn->prepare($update_sql);
                $stmt->bind_param("sss", $formattedDate, $daysWithSuffix, $userid);
                $execute = $stmt->execute();

                if ($execute) {
                    // Successful update
                    $response = array('status' => true, 'message' => 'User details updated successfully.');
                } else {
                    // Error in database update
                    $response = array('status' => false, 'message' => 'Error: ' . $stmt->error);
                }
            } else {
                // User doesn't exist, perform the insert
                $insert_sql = "INSERT INTO cycleupdate (Userid, date, days) VALUES (?, ?, ?)";
                $stmt = $conn->prepare($insert_sql);
                $stmt->bind_param("sss", $userid, $formattedDate, $daysWithSuffix);
                $execute = $stmt->execute();

                if ($execute) {
                    // Successful insert
                    $response = array('status' => true, 'message' => 'New user details inserted successfully.');
                } else {
                    // Error in database insert
                    $response = array('status' => false, 'message' => 'Error: ' . $stmt->error);
                }
            }
        } else {
            // Error in query execution
            $response = array('status' => false, 'message' => 'Error in query execution: ' . $stmt->error);
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
