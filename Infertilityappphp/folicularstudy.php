<?php
// Include your database connection code here (e.g., db_conn.php)
require_once('con.php');

// Check if the request is a POST request
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Get input data from the application
    $id = $_POST['id'];
    $userid = $_POST['userid'];
    $day = $_POST['day'];
    $date = $_POST['date'];
    $leftovery = $_POST['leftovery'];
    $rightovery = $_POST['rightovery'];

    // Check if the user_id already exists in foliculardata for the given date
    $check_sql = "SELECT Userid FROM foliculardata WHERE Userid = '$userid' AND Date = '$date'";
    $check_result = $conn->query($check_sql);

    if ($check_result->num_rows > 0) {
        // User already exists for the specified date
        $response = array('status' => 'error', 'message' => 'User already exists for this date.');
        echo json_encode($response);
    } else {
        // Insert data into the foliculardata table
        $sql = "INSERT INTO foliculardata (id, Userid, Date, Day, Leftovery, Rightover) VALUES ('$id','$userid', '$date', '$day', '$leftovery', '$rightovery')";

        if ($conn->query($sql) === TRUE) {
            // Successful insertion
            $response = array('status' => 'success', 'message' => 'folicular report of the patient added sucessfully.');
            echo json_encode($response);
        } else {
            // Error in database insertion
            $response = array('status' => 'error', 'message' => 'Error: ' . $conn->error);
            echo json_encode($response);
        }
    }
} else {
    // Handle non-POST requests (e.g., return an error response)
    $response = array('status' => 'error', 'message' => 'Invalid request method.');
    echo json_encode($response);
}

// Close the database connection
$conn->close();
?>
