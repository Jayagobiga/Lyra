<?php
// Include your database connection code here (e.g., db_conn.php)
require_once('dbconnect.php');

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// Replace with actual table and column names
$userId = $_GET['userid']; // Get user id from the request

$sql = "SELECT date, days, fertileStart, fertileEnd FROM cycleupdate WHERE userid = '$userId'";
$result = $conn->query($sql);

if ($result->num_rows > 0) {
    // Output data of each row
    $row = $result->fetch_assoc();
    $data = array(
        'date' => $row['date'],
        'days' => $row['days'],
        'fertileStart' => $row['fertileStart'],
        'fertileEnd' => $row['fertileEnd']
    );
    echo json_encode($data);
} else {
    echo "0 results";
}
$conn->close();
?>
