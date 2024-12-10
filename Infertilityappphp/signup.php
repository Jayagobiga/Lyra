<?php
// Include your database connection code here (e.g., db_conn.php)
//require_once('dbconnect.php');
$conn  = mysqli_connect("localhost", "root", "", "infertility");

// Check if the request is a POST request
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Get input data from the application

    // $role= $_POST['role'];
    $userid = $_POST['userid'];
    $password = $_POST['password'];
    $reenterpass = $_POST['reenterpass'];
    $firstname = $_POST['firstname'];
    $email = $_POST['email'];
    $contactno = $_POST['contactno'];
    $specification = $_POST['specification'];
   

    // Check if the user_id already exists in transporter_signup
    $check_sql = "SELECT Userid FROM signup WHERE Userid = '$userid'";
    $check_result = $conn->query($check_sql);

    if ($check_result->num_rows > 0) {
        // User already exists
        $response = array('status' => 'error', 'message' => 'User already exists.');
        echo json_encode($response);
    } else {
        // Insert data into the transporter_signup table
        $sql = "INSERT INTO signup (Userid, Password,reenterpassword,FirstName,Email,PhoneNumber,specification) VALUES (
        '$userid', '$password','$reenterpass', '$firstname','$email','$contactno','$specification')";

        if ($conn->query($sql) === TRUE) {
            // Successful insertion
            $response = array('status' => 'success', 'message' => 'User registration successful.');
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