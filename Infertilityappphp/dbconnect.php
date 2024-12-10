<?php
// Set the header to return JSON content
header('Content-Type: application/json');

// Database connection parameters
$servername = "localhost"; // Change this if your database is hosted on a different server
$username = "root"; // Replace with your MySQL username
$password = ""; // Replace with your MySQL password
$database = "infertilityapp"; // Replace with your database name

// Create connection
$conn = new mysqli($servername, $username, $password, $database);

// Check connection
if ($conn->connect_error) {
    // Return a JSON response in case of connection failure
    echo json_encode(array("status" => "error", "message" => "Connection failed: " . $conn->connect_error));
    exit();
}

// // Return a success message if the connection is successful
// echo json_encode(array("status" => "success", "message" => "Connected successfully"));
?>
