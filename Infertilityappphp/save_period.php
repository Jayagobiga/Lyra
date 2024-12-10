<?php
// Include your database connection code here (e.g., db_conn.php)
require_once('dbconnect.php');

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// Handle POST request
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    // Validate and sanitize input
    $userId = $_POST['userid'];
    $date = $_POST['date'];
    $days = $_POST['days'];

    // Update query
    $sql = "UPDATE cycleupdate SET date = '$date', days = '$days' WHERE userid = '$userId'";

    if ($conn->query($sql) === TRUE) {
        echo "Period data updated successfully";
    } else {
        echo "Error updating period data: " . $conn->error;
    }
} else {
    echo "Method not allowed";
}

$conn->close();
?>
