<?php
require_once('dbconnect.php');

// Check if the request is a POST request and if required fields are provided
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['userId'], $_POST['medication'], $_POST['time'], $_POST['dosage'], $_POST['route'])) {
    // Get input data from the application
    $userId = $_POST['userId'];
    $medication = $_POST['medication'];
    $time = $_POST['time'];
    $dosage = $_POST['dosage'];
    $route = $_POST['route'];
    
    // Get the current date and format it as Y-m-d
    $date = date("Y-m-d");

    // Prepare SQL statement to insert data into the medicationdetails table
    $sql = "INSERT INTO medicationdetails (Userid, Medication, Time, Dosage, Route, Date) VALUES (?, ?, ?, ?, ?, ?)";
    $stmt = $conn->prepare($sql);

    if ($stmt) {
        // Bind parameters and execute the query
        $stmt->bind_param('ssssss', $userId, $medication, $time, $dosage, $route, $date);
        if ($stmt->execute()) {
            // Successful insertion
            $response = array('status' => true, 'message' => 'Medication was added successfully.');
            echo json_encode($response);
        } else {
            // Error in database insertion
            $response = array('status' => false, 'message' => 'Error: ' . $stmt->error);
            echo json_encode($response);
        }
        $stmt->close();
    } else {
        // Error preparing the SQL statement
        $response = array('status' => false, 'message' => 'Error preparing the SQL statement.');
        echo json_encode($response);
    }
} else {
    // Required fields not provided in the request
    $response = array('status' => false, 'message' => 'Required fields are missing in the request.');
    echo json_encode($response);
}

// Close the database connection
$conn->close();
?>
