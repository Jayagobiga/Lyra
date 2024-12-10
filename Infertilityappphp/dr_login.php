<?php
require("dbconnect.php"); 

// Get the form data from the request
$username = $_POST['dr_userid'];
$password = $_POST['password'];

// Prepare and execute the SQL query using prepared statements to prevent SQL injection
$stmt = $conn->prepare("SELECT * FROM doctor_profile WHERE dr_userid = ? AND password = ?");
$stmt->bind_param("ss", $username, $password);
$stmt->execute();
$result = $stmt->get_result();

// Check if any rows were returned
if ($result->num_rows > 0) {
    // Login successful
    $response = array('status' => 'success', 'message' => 'Login successful');
} else {
    // Login failed
    $response = array('status' => 'failure', 'message' => 'Invalid user ID or password');
}

// Send response as JSON
header('Content-Type: application/json');
echo json_encode($response);

// Close the prepared statement and connection
$stmt->close();
$conn->close();
?>
