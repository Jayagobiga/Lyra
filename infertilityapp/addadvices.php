<?php
// Include your database connection code here (e.g., db_conn.php)
require_once('dbconnect.php');

// Check if the request is a POST request
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Get input data from the application
    $userid = $_POST['userid'];
    $date = $_POST['date'];
    $addadvice = $_POST['addadvice'];

    // Check if the combination of Userid and Date already exists in advices
    $check_sql = "SELECT Userid FROM advices WHERE Userid = '$userid' AND date = '$date'";
    $check_result = $conn->query($check_sql);

    if ($check_result->num_rows > 0) {
        // User and date combination already exists
        // Add another advice entry for the same user and date
        $update_sql = "UPDATE advices SET Addadvices = CONCAT(Addadvices, '\n', '$addadvice') WHERE Userid = '$userid' AND date = '$date'";
        
        if ($conn->query($update_sql) === TRUE) {
            // Successful update
            $response = array('status' => true, 'message' => 'Advice added successfully.');
            echo json_encode($response);
        } else {
            // Error in database update
            $response = array('status' => false, 'message' => 'Error: ' . $conn->error);
            echo json_encode($response);
        }
    } else {
        // Insert a new row for the user and date combination
        $insert_sql = "INSERT INTO advices (Userid, Date, Addadvices) VALUES ('$userid', '$date', '$addadvice')";
        
        if ($conn->query($insert_sql) === TRUE) {
            // Successful insertion
            $response = array('status' => true, 'message' => 'Advice added successfully.');
            echo json_encode($response);
        } else {
            // Error in database insertion
            $response = array('status' => false, 'message' => 'Error: ' . $conn->error);
            echo json_encode($response);
        }
    }
} else {
    // Handle non-POST requests (e.g., return an error response)
    $response = array('status' => false, 'message' => 'Invalid request method.');
    echo json_encode($response);
}

// Close the database connection
$conn->close();
?>
