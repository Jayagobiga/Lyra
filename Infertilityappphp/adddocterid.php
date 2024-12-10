<?php
require_once('dbconnect.php');

// Check if the request is a POST request
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Get input data from the application
    $dr_name = isset($_POST['dr_name']) ? $_POST['dr_name'] : 'welcome';
    $email = isset($_POST['email']) ? $_POST['email'] : '@gmail.com';
    $designation = isset($_POST['designation']) ? $_POST['designation'] : 'designation';
    $contact_no = isset($_POST['contact_no']) ? $_POST['contact_no'] : 'contactnumber';
    $password = isset($_POST['password']) ? $_POST['password'] : 'welcome'; // Assuming password has a default value
    $repassword = isset($_POST['repassword']) ? $_POST['repassword'] : ''; // Assuming repassword has no default value

    // Insert data into the doctor_profile table
    $sql = "INSERT INTO doctor_profile (dr_name, email, designation, contact_no, password, repassword) VALUES (?, ?, ?, ?, ?, ?)";
    $stmt = $conn->prepare($sql);
    $stmt->bind_param("ssssss", $dr_name, $email, $designation, $contact_no, $password, $repassword);

    if ($stmt->execute()) {
        // Successful insertion
        $dr_userid = $stmt->insert_id; // Get the last inserted ID
        $response = array('status' => true, 'message' => 'Doctor registration successful.', 'dr_userid' => $dr_userid);
        echo json_encode($response);
    } else {
        // Error in database insertion
        $response = array('status' => false, 'message' => 'Error: ' . $conn->error);
        echo json_encode($response);
    }

    $stmt->close();
} else {
    // Handle non-POST requests (e.g., return an error response)
    $response = array('status' => false, 'message' => 'Invalid request method.');
    echo json_encode($response);
}

// Close the database connection
$conn->close();
?>
