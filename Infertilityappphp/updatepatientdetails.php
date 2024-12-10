<?php
// Include your database connection code here (e.g., db_conn.php)
require_once('dbconnect.php');

// Check if the request is a POST request
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Get input data from the application
    
    $userid = $_POST['userid'];
    $name = $_POST['name'];
    $contactno = $_POST['contactno'];
    $age = $_POST['age'];
    $gender = $_POST['gender'];
    $height = $_POST['height'];
    $weight = $_POST['weight'];
    $address = $_POST['address'];
    $marriageyear = $_POST['marriageyear'];
    $bloodgroup = $_POST['bloodgroup'];
    $medicalhistory = $_POST['medicalhistory'];
    $specifications = $_POST['specifications'];


    // Check if the user_id already exists in medicationdetails
    $check_sql = "SELECT Userid FROM addpatient WHERE Userid = '$userid'";
    $check_result = $conn->query($check_sql);

    if ($check_result->num_rows > 0) {
        // User exists, perform the update
        $update_sql = "UPDATE addpatient SET 
                        Name = '$name',
                        ContactNo = '$contactno',
                        Age = '$age',
                        Gender = '$gender',
                        Height = '$height',
                        Weight = '$weight',
                        Address = '$address',
                        Marriageyear = '$marriageyear',
                        Bloodgroup = '$bloodgroup',
                        Medicalhistory = '$medicalhistory',
                        Specifications = '$specifications'
                      WHERE Userid = '$userid'";

        if ($conn->query($update_sql) === TRUE) {
            // Successful update
            $response = array('status' => true , 'message' => 'patient details updated successfully.');
            echo json_encode($response);
        } else {
            // Error in database update
            $response = array('status' => false, 'message' => 'Error: ' . $conn->error);
            echo json_encode($response);
        }
    } else {
        // User doesn't exist, return an error response
        $response = array('status' => true, 'message' => 'User does not exist. You can only update existing users.');
        echo json_encode($response);
    }
} else {
    // Handle non-POST requests (e.g., return an error response)
    $response = array('status' => false, 'message' => 'Invalid request method.');
    echo json_encode($response);
}

// Close the database connection
$conn->close();
?>
